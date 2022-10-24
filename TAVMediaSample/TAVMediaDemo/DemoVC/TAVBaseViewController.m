/////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Tencent is pleased to support the open source community by making TAVMedia available.
//
//  Copyright (C) 2022 THL A29 Limited, a Tencent company. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  unless required by applicable law or agreed to in writing, software distributed under the
//  license is distributed on an "as is" basis, without warranties or conditions of any kind,
//  either express or implied. see the license for the specific language governing permissions
//  and limitations under the license.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

#import "TAVBaseViewController.h"
#import "PcmPlayer.h"

#import <TAVMedia/TAVVideoReader.h>
#import <TAVMedia/TAVAudioReader.h>

@interface TAVBaseViewController ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) TAVVideoReader *videoReader;
@property (nonatomic, strong) TAVAudioReader *audioReader;
@property (nonatomic, strong) PcmPlayer *pcmPlayer;
@property (nonatomic, assign) CFAbsoluteTime videoStartTime;
@property (nonatomic, strong) TAVMovie *movie;
@end

@implementation TAVBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGL];
    [self setupDisplayLink];
    [self testVideo];
    [self startAnimation];
    [_pcmPlayer start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self stopAnimation];
    [_pcmPlayer stop];
}

#pragma mark - 构造播放环境

- (void)setupGL {
    self.glLayer = [CAEAGLLayer layer];
    self.glLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.glLayer.contentsScale = 2.0;
    [self.view.layer insertSublayer:self.glLayer atIndex:0];
    self.glLayer.drawableProperties = @{ kEAGLDrawablePropertyRetainedBacking: @NO, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8 };
}

- (void)setupDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePicture)];
    self.displayLink.paused = YES;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)testVideo {
    // 视频素材测试
    self.movie = [self makeRootComposition];

    // 构建videoReader，用于控制视频的播放，frameRate可以根据业务的需求进行设置
    _videoReader = [TAVVideoReader MakeFrom:self.movie frameRate:60];
    [_videoReader setScaleMode:TAVScaleModeLetterBox];
    [_videoReader seekTo:0];
    // 构建surface，用于给videoReader提供显示目标
    self.surface = [TAVSurface FromLayer:self.glLayer];
    [_videoReader setSurface:self.surface];

    // 构建audioReader，用于控制音频的播放，采样率、采样数、声道数可以根据业务需求进行设置
    _audioReader = [TAVAudioReader MakeFrom:self.movie sampleRate:44100 sampleCount:1024 channels:1];
    [_audioReader seekTo:0];

    // 简单的自制pcm数据播放器，用于播放声音，音频和视频建议放在不同线程处理，防止视频渲染卡顿导致音频卡顿
    // 这边只是简单的进行了音画同步，可能并不满足业务要求，业务需要按照自己的需求进行处理
    _pcmPlayer = [[PcmPlayer alloc] init];
    _pcmPlayer.audioReader = _audioReader;
}

- (NSInteger)currentVideoTime {
    return (CFAbsoluteTimeGetCurrent() - self.videoStartTime) * 1000 * 1000;
}

- (void)updatePicture {
    // 当时长超过duration时，将进度重置回0
    if ([self currentVideoTime] > self.movie.duration) {
        self.videoStartTime = CFAbsoluteTimeGetCurrent();
        [self.videoReader seekTo:0];
        [self.audioReader seekTo:0];
    }
    // 当调用seekTo后，readNextFrame会渲染seekTo的当前帧数据
    // 当未调用seekTo时，每次readNextFrame会使videoReader内部的时间按照帧率自增
    [self.videoReader readNextFrame];
}

- (void)startAnimation {
    self.displayLink.paused = NO;
    self.videoStartTime = CFAbsoluteTimeGetCurrent();
}

- (void)stopAnimation {
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - 构造数据

- (TAVComposition *)makeRootComposition {
    // TAVMedia时间数据都以微秒为单位，totalDuration在TAVMedia中实际表示为3秒
    NSInteger totalDuration = 3 * 1000 * 1000;
    NSInteger maxWidth = 0;

#pragma mark - 播放视频
    // 构造需要播放的视频结构
    NSURL *movieFilePath = [[NSBundle mainBundle] URLForResource:@"video-640x360" withExtension:@"mp4"];
    // asset是所需要的资源数据
    TAVMovieAsset *movieAsset = [TAVMovieAsset MakeFromPath:movieFilePath.absoluteString];
    // movie继承自clip，表示asset的一个片段，用于在VideoReader/AudioReader中进行播放
    // MakeFrom中startTime表示movie在asset中的开始时间，duration表示movie在asset中的截取时长
    // Make构造时的startTime和duration目前没有提供修改接口
    TAVMovie *movie = [TAVMovie MakeFrom:movieAsset startTime:0 duration:totalDuration];
    // 与Make函数中不同，setStartTime表示的是在父级composition容器中的开始时间，不再是表示asset的开始时间
    [movie setStartTime:0];
    // 与Make函数中不同，setDuration表示的是在父级composition容器中的时长，不再是表示asset的截取时长
    [movie setDuration:totalDuration];

    maxWidth = movieAsset.width;

#pragma mark - 播放图片
    // 图片转视频
    NSURL *imageFilePath = [[NSBundle mainBundle] URLForResource:@"hermione" withExtension:@"jpg"];
  NSLog(@"path :%@",imageFilePath.path);
    TAVImageAsset *imageAsset = [TAVImageAsset MakeFromPath:imageFilePath.path];

    // Movie可以通过不同的asset创建，除了MovieAsset（for视频），还可以是ImageAsset（for图片），PAGAsset(for PAG文件)
    TAVMovie *imageMovie = [TAVMovie MakeFrom:imageAsset startTime:0 duration:totalDuration];
    [imageMovie setStartTime:0];
    [imageMovie setDuration:totalDuration];
    // 设置Matrix可以改变clip的在父composition中的位置，0，0点默认是位于父级Composition的左上角
    [imageMovie setMatrix:CGAffineTransformMakeTranslation(0, movieAsset.height + 10)];
    maxWidth = MAX(maxWidth, imageAsset.width);

    // 构造父级Composition容器，用于包裹图片和视频clip
    TAVComposition *compositon = [TAVComposition Make:maxWidth height:movieAsset.height + imageAsset.height + 10 startTime:0 duration:totalDuration];
    // 将视频clip添加到composition中
    [compositon addClip:movie];
    // 将图片clip添加到composition中
    [compositon addClip:imageMovie];
    // 设置composition的时长
    [compositon setDuration:totalDuration];
    return compositon;
}

@end
