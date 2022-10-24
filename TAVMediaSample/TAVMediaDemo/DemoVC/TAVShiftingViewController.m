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

#import "TAVShiftingViewController.h"

@interface TAVShiftingViewController ()

@end

@implementation TAVShiftingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (TAVMovie *)makeShiftingMovie:(CGFloat)speed {
    NSInteger totalDuration = 10 * 1000 * 1000;
    NSString *movieFilePath = [[NSBundle mainBundle] pathForResource:@"video-640x360" ofType:@"mp4"];
    TAVMovieAsset *asset = [TAVMovieAsset MakeFromPath:movieFilePath];
    TAVMovie *movie = [TAVMovie MakeFrom:asset startTime:0 duration:totalDuration * speed];
    [movie setStartTime:0];
    [movie setDuration:totalDuration];
    return movie;
}

- (TAVComposition *)makeShiftingComposition:(CGFloat)speed {
    NSInteger totalDuration = 10 * 1000 * 1000;

    // 构造content
    NSString *movieFilePath = [[NSBundle mainBundle] pathForResource:@"video-640x360" ofType:@"mp4"];
    TAVMovieAsset *asset = [TAVMovieAsset MakeFromPath:movieFilePath];
    TAVMovie *movie = [TAVMovie MakeFrom:asset startTime:0 duration:asset.duration];
    [movie setDuration:asset.duration];

    // composition变速，注意：当movie时长比compositionContentDuration小时，composition后续画面会是黑帧
    TAVComposition *composition = [TAVComposition Make:640 height:360 startTime:0 duration:totalDuration * speed];
    [composition setDuration:totalDuration];
    [composition addClip:movie];
    return composition;
}

- (TAVComposition *)makeRootComposition {
    NSInteger totalDuration = 10 * 1000 * 1000;
#pragma mark - 直接通过movie变速
    // 变速方法可以通过movie自身变速，也可以通过父级的composition来进行变速
    // case 1： 通过movie变速
    // 原速
    TAVMovie *movie = [self makeShiftingMovie:1.f];

    // 2倍速
    TAVMovie *fastMovie = [self makeShiftingMovie:2.f];
    [fastMovie setMatrix:CGAffineTransformMakeTranslation(0, 360 + 10)];

    // 0.5倍速
    TAVMovie *slowMovie = [self makeShiftingMovie:0.5f];
    [slowMovie setMatrix:CGAffineTransformMakeTranslation(0, 2 * 360 + 20)];

    // 定格
    TAVMovie *frozenMovie = [self makeShiftingMovie:0];
    [frozenMovie setMatrix:CGAffineTransformMakeTranslation(0, 3 * 360 + 30)];

    TAVComposition *composition = [TAVComposition Make:640 * 2 + 10 height:360 * 4 + 30 startTime:0 duration:totalDuration];
    [composition addClip:movie];
    [composition addClip:fastMovie];
    [composition addClip:slowMovie];
    [composition addClip:frozenMovie];

#pragma mark - 通过Composition变速
    //  case 2: 通过composition变速
    TAVComposition *shiftingComposition = [TAVComposition Make:640 height:360 * 4 + 30 startTime:0 duration:totalDuration];
    [shiftingComposition setDuration:totalDuration];

    // 原速
    TAVComposition *compositionMovie = [self makeShiftingComposition:1.f];

    // 2倍速
    TAVComposition *fastComposition = [self makeShiftingComposition:2.f];
    [fastComposition setMatrix:CGAffineTransformMakeTranslation(0, 360 + 10)];

    // 0.5倍速
    TAVComposition *slowComposition = [self makeShiftingComposition:0.5f];
    [slowComposition setMatrix:CGAffineTransformMakeTranslation(0, 2 * 360 + 20)];

    // 定格
    TAVComposition *frozenComposition = [self makeShiftingComposition:0];
    [frozenComposition setMatrix:CGAffineTransformMakeTranslation(0, 3 * 360 + 30)];

    [shiftingComposition addClip:compositionMovie];
    [shiftingComposition addClip:fastComposition];
    [shiftingComposition addClip:slowComposition];
    [shiftingComposition addClip:frozenComposition];

    [shiftingComposition setMatrix:CGAffineTransformMakeTranslation(640 + 10, 0)];

    [composition addClip:shiftingComposition];
    [composition setDuration:totalDuration];
    return composition;
}

@end
