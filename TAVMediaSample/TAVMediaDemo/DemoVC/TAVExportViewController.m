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

#import "TAVExportViewController.h"

#import <AVKit/AVKit.h>
#import <TAVMedia/TAVExport.h>

@interface TAVExportViewController () <TAVMediaExportDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *exportBtn;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) TAVExport *exporter;

@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@end

@implementation TAVExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player pause];
    self.player = nil;
}

- (NSString *)exportPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"test.mp4"];
}

- (void)initPlayer {
    if (self.player != nil) {
        return;
    }
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:[self exportPath]]];
    if (self.player == nil) {
        return;
    }
    self.playerLayer = [[AVPlayerLayer alloc] init];
    self.playerLayer.frame = self.view.frame;
    self.playerLayer.player = self.player;
    [self.view.layer insertSublayer:self.playerLayer atIndex:0];
}

- (TAVMovie *)makeExportMovie {
    NSInteger movieDuration = 6 * 1000 * 1000;
    TAVComposition *movieComposition = [TAVComposition Make:720 height:1280 startTime:0 duration:movieDuration];
    [movieComposition setDuration:movieDuration];

    // ??????PAG??????????????????
    NSString *backgroundPag = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"pag"];
    TAVPAGAsset *backgroundAsset = [TAVPAGAsset MakeFromPath:backgroundPag];
    TAVPAGSticker *background = [TAVPAGSticker MakeFrom:backgroundAsset];
    // ????????????
    [background replace:0 color:UIColor.brownColor];
    [background setDuration:movieDuration];
    // ????????????composition
    [background setMatrix:CGAffineTransformMakeScale(720 / backgroundAsset.width, 1280 / backgroundAsset.height)];
    [movieComposition addClip:background];

    // ??????movie
    NSString *moviefilePath4 = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"mp4"];
    TAVAsset *movieAsset = [TAVMovieAsset MakeFromPath:moviefilePath4];
    TAVMovie *movie4 = [TAVMovie MakeFrom:movieAsset startTime:0 duration:movieDuration];
    [movie4 setDuration:movieDuration];
    [movie4 setCropRect:CGRectMake(50, 50, movieAsset.width - 100, movieAsset.height - 100)];
    [movieComposition addClip:movie4];

    // ??????????????????
    NSString *stickerPath = [[NSBundle mainBundle] pathForResource:@"font" ofType:@"pag"];
    TAVPAGAsset *stickerAsset = [TAVPAGAsset MakeFromPath:stickerPath];
    TAVPAGSticker *sticker = [TAVPAGSticker MakeFrom:stickerAsset];
    // [sticker numTexts] / [sticker numImages] ????????????????????????????????????
    // ??????replace???layerIndex??????????????????0???numTexts / replace Image???layerIndex???????????????0~numImages
    [sticker replace:0 text:@"????????????movie4??????sticker"];
    [sticker setDuration:movieDuration / 2];
    [movieComposition addClip:sticker];
    return movieComposition;
}

- (IBAction)playExportVideo:(id)sender {
    if (self.player == nil) {
        [self initPlayer];
    }
    if (self.player == nil) {
        return;
    }
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (IBAction)export:(id)sender {
    TAVExportConfig *config = [TAVExportConfig new];
    TAVMovie *movie = [self makeExportMovie];
    config.videoWidth = movie.width;
    config.videoHeight = movie.height;
    config.outPath = [self exportPath];
    self.exporter = [TAVExport MakeMediaExport:movie config:config delegate:self];
    [self.exporter exportMedia];
}

#pragma mark - TAVMediaExportDelegate

- (void)onError:(TAVExportType)type errorCode:(TAVExportErrorCode)errorCode {
    NSLog(@"error errorCode: %d", errorCode);
}

- (void)onProgress:(TAVExportType)type progress:(CGFloat)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = progress;
    });
}

- (void)onCompletion:(TAVExportType)type status:(NSDictionary<NSString *, NSString *> *)status {
    NSLog(@"completion");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;
        self.exportBtn.enabled = NO;
        // ???????????????????????????
        self.exporter = nil;
        [self initPlayer];
    });
}

@end
