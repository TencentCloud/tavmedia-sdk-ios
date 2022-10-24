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


#import "TAVTemplateViewController.h"
#import <TAVMedia/TAVEffect.h>
#define MOVIE_DURATION 5 * 1000 * 1000

@interface TAVTemplateViewController ()

@property (assign, nonatomic) bool vertical;

@end

@implementation TAVTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vertical = YES;
    // Do any additional setup after loading the view.
}

- (TAVComposition *)makeMovieWithEffect:(CGSize)size {
    TAVComposition *movieComposition = [TAVComposition Make:size.width height:size.height startTime:0 duration:MOVIE_DURATION];
    [movieComposition setDuration:MOVIE_DURATION];

    // 通过PAG文件添加背景
    NSString *backgroundPag = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"pag"];
    TAVPAGAsset *backgroundAsset = [TAVPAGAsset MakeFromPath:backgroundPag];
    TAVPAGSticker *background = [TAVPAGSticker MakeFrom:backgroundAsset];
    // 设置颜色
    [background replace:0 color:UIColor.redColor];
    [background setDuration:MOVIE_DURATION];
    // 拉伸到全composition
    [background setMatrix:CGAffineTransformMakeScale(size.width / backgroundAsset.width, size.height / backgroundAsset.height)];
    [movieComposition addClip:background];

  
    // 添加movie
    NSString *moviefilePath4 = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"mp4"];
    TAVAsset *movieAsset = [TAVMovieAsset MakeFromPath:moviefilePath4];
    TAVMovie *movie4 = [TAVMovie MakeFrom:movieAsset startTime:0 duration:MOVIE_DURATION];
    [movie4 setDuration:MOVIE_DURATION];
    [movie4 setCropRect:CGRectMake(50, 50, movieAsset.width - 100, movieAsset.height - 100)];

    [movie4 setMatrix:CGAffineTransformMakeRotation(50)];
    
    // 添加亮度调节
    TAVColorTuning *params = [TAVColorTuning new];
    params.gamma = [TAVProperty new];
    params.gamma.value = @30;
    TAVColorTuningEffect* colorTuning = [TAVColorTuningEffect Make:params];
    [colorTuning addInput:movie4];
    [colorTuning setStartTime:0 * 1000 * 1000];
    [colorTuning setDuration:MOVIE_DURATION - 3 * 1000 * 1000];
    [movieComposition addClip:colorTuning];
    
    // 添加lut
    NSString* lutPath = [[NSBundle mainBundle] pathForResource:@"lut1" ofType:@"png"];
    TAVLUTEffect* lutEffect = [TAVLUTEffect Make:lutPath];
    [lutEffect addInput:colorTuning];
    [lutEffect setStartTime:2 * 1000 * 1000];
    [lutEffect setDuration:MOVIE_DURATION - 2 * 1000 * 1000];
    [movieComposition addClip:lutEffect];
  
    // 添加文字贴纸
    NSString *stickerPath = [[NSBundle mainBundle] pathForResource:@"font" ofType:@"pag"];
    TAVPAGAsset *stickerAsset = [TAVPAGAsset MakeFromPath:stickerPath];
    TAVPAGSticker *sticker = [TAVPAGSticker MakeFrom:stickerAsset];
    // [sticker numTexts] / [sticker numImages] 可以获取到有多少替换图层
    [sticker
        replace:0
           text:@"只显示在movie4上的sticker"];  // 这里replace的layerIndex的取值范围是0～numTexts / replace Image的layerIndex取值范围是0~numImages
    [sticker setDuration:MOVIE_DURATION / 2];
  
  
    [movieComposition addClip:sticker];

    return movieComposition;
}

- (CGAffineTransform)aspectFit:(CGSize)source target:(CGSize)target {
    CGFloat scale = target.width / source.width;
    if (source.height * scale > target.height) {
        scale = target.height / source.height;
    }
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    CGFloat offsetX = (target.width - source.width * scale) / 2;
    CGFloat offsetY = (target.height - source.height * scale) / 2;
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(offsetX, offsetY));
    return transform;
}

- (TAVComposition *)makeVideoTrackComposition:(CGSize)rootSize {
    // ——————————————————————————————timeline——————————————————————————>
    //
    // —————movie1——————
    //      ———————movie2————————————
    //                     ——————————movie3————————————
    //                                     ——————background——————
    //                                     ————————movie4————————
    //                                     ————sticker—————
    //      -transition1-
    //                     -transition2-
    //                                     -transition3-
    NSString *moviefilePath1 = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSString *moviefilePath2 = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp4"];
    NSString *moviefilePath3 = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"mp4"];
    TAVMovieAsset *movieAsset = [TAVMovieAsset MakeFromPath:moviefilePath1];
    NSInteger movieDuration = MOVIE_DURATION;
    TAVMovie *movie1 = [TAVMovie MakeFrom:movieAsset startTime:0 duration:movieDuration];
    [movie1 setDuration:movieDuration];
    [movie1 setMatrix:[self aspectFit:CGSizeMake(movieAsset.width, movieAsset.height) target:rootSize]];

    movieAsset = [TAVMovieAsset MakeFromPath:moviefilePath2];
    TAVMovie *movie2 = [TAVMovie MakeFrom:movieAsset startTime:0 duration:movieDuration];
    [movie2 setDuration:movieDuration];
    [movie2 setMatrix:[self aspectFit:CGSizeMake(movieAsset.width, movieAsset.height) target:rootSize]];

    movieAsset = [TAVMovieAsset MakeFromPath:moviefilePath3];
    TAVMovie *movie3 = [TAVMovie MakeFrom:movieAsset startTime:0 duration:movieDuration];
    [movie3 setDuration:movieDuration];
    [movie3 setMatrix:[self aspectFit:CGSizeMake(movieAsset.width, movieAsset.height) target:rootSize]];

    TAVMovie *movie4 = [self makeMovieWithEffect:rootSize];

    // 构造转场
    TAVPAGEffect *transition1 = [TAVPAGEffect MakeFrom:[[NSBundle mainBundle] pathForResource:@"ZC1" ofType:@"pag"]];
    [transition1 setDuration:transition1.fileDuration];
    TAVPAGEffect *transition2 = [TAVPAGEffect MakeFrom:[[NSBundle mainBundle] pathForResource:@"ZC2" ofType:@"pag"]];
    [transition2 setDuration:transition2.fileDuration];
    TAVPAGEffect *transition3 = [TAVPAGEffect MakeFrom:[[NSBundle mainBundle] pathForResource:@"ZC3" ofType:@"pag"]];
    [transition3 setDuration:transition3.fileDuration];

    // 按照时间线排布结构
    [movie2 setStartTime:movieDuration - transition1.duration];
    [transition1 setStartTime:movie2.startTime];
    [movie3 setStartTime:movieDuration * 2 - transition1.duration - transition2.duration];
    [transition2 setStartTime:movie3.startTime];
    [movie4 setStartTime:movieDuration * 3 - transition1.duration - transition2.duration - transition3.duration];
    [transition3 setStartTime:movie4.startTime];

    // 将PAG的展位图层替换成对应的movie
    [transition1 addInput:movie1];
    [transition1 addInput:movie2];

    // replace第一个参数指layerIndex（表示对应替换图层的index）， 第二个参数指effect在之前添加input的index，在这个例子中：inputIndex0->movie1,
    // inputIndex1->movie2， 第三个是input相对替换涂层的matrix，如果不填默认按图层内置的伸缩模式进行处理
    [transition1 replace:0 inputIndex:0];
    [transition1 replace:1 inputIndex:1];

    // 这里设置transition2的输入是transition1，防止由于Movie时间过短，在transition1还未结束的时候进入transition2，导致transition1的效果丢失
    [transition2 addInput:movie2];
    [transition2 addInput:movie3];
    [transition2 replace:0 inputIndex:0];
    [transition2 replace:1 inputIndex:1];

    [transition3 addInput:movie3];
    [transition3 addInput:movie4];
    [transition3 replace:0 inputIndex:0];
    [transition3 replace:1 inputIndex:1];

    // 将视频和转场组成一个整体，方便后续使用
    TAVComposition *composition = [TAVComposition Make:rootSize.width height:rootSize.height startTime:0 duration:movie4.startTime + movie4.duration];
    [composition addClip:transition1];
    [composition addClip:transition2];
    [composition addClip:transition3];
    [composition setDuration:movie4.startTime + movie4.duration];
    return composition;
}

- (TAVComposition *)makeRootComposition {
    /// 整体模版时间轴
    // ——————————————————————————————timeline——————————————————————————>
    //
    // ———————————————————————视频轨道 videoTrack————————————————————————
    //
    // ——————片头pt——————
    //
    // ——————————————————-——氛围fw(跨越多个movie)—————————————————————————
    //
    //                                               ———————片尾pw——————
    //
    //
    //
    CGSize displaySize = CGSizeMake(720, 1280);
    // 视频轨道
    TAVComposition *videoTrack = [self makeVideoTrackComposition:displaySize];

    // 特效的容器Composition
    TAVComposition *effectComposition = [TAVComposition Make:displaySize.width height:displaySize.height startTime:0 duration:videoTrack.duration];
    [effectComposition setDuration:videoTrack.duration];
    [effectComposition addClip:videoTrack];

    // 片头
    TAVPAGEffect *pt = [TAVPAGEffect MakeFrom:[[NSBundle mainBundle] pathForResource:@"PT" ofType:@"pag"]];
    [pt setDuration:pt.fileDuration];
    if (pt.numImages > 0) {
        [pt addInput:videoTrack];
        [pt replace:0 inputIndex:0];
    }

    // 氛围， 一个effect跨越多个movie
    TAVPAGEffect *fw = [TAVPAGEffect MakeFrom:[[NSBundle mainBundle] pathForResource:@"FW" ofType:@"pag"]];
    [fw setDuration:effectComposition.duration];
    // 设置fileDuration->duration时特效循环的行为是Repeat
    [fw setTimeStretchMode:TAVTimeStretchModeRepeat];
    if (fw.numImages > 0) {
        [fw addInput:pt];
        [fw replace:0 inputIndex:0];
    }
    [effectComposition addClip:fw];

    // 片尾
    TAVPAGEffect *pw = [TAVPAGEffect MakeFrom:[[NSBundle mainBundle] pathForResource:@"PW" ofType:@"pag"]];
    [pw setDuration:pw.fileDuration];
    [pw setStartTime:effectComposition.duration - pw.fileDuration];
    if (pw.numTexts > 0) {
        [pw replace:0 text:@"hello world"];
    }
    [effectComposition addClip:pw];

    return effectComposition;
}

- (IBAction)resize:(id)sender {
  self.vertical = !self.vertical;
  if (self.vertical) {
    CGRect bounds = self.view.bounds;
    CGFloat scale = CGRectGetWidth(bounds) / 720;
    self.glLayer.frame = CGRectMake(0, 0, scale * 720, scale * 1280);
    [self.surface updateSize];
  } else {
    CGRect bounds = self.view.bounds;
    CGFloat scale = CGRectGetWidth(bounds) / 1280;
    self.glLayer.frame = CGRectMake(0, 0, scale * 1280, scale * 720);
    [self.surface updateSize];
  }
}

@end
