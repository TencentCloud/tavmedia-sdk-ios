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

#import "TAVAudioViewController.h"
#include <TAVMedia/TAVEffect.h>

@interface TAVAudioViewController ()

@end

@implementation TAVAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (TAVComposition *)makeRootComposition {
    NSInteger totalDuration = 10 * 1000 * 1000;
    TAVComposition *compostion = [TAVComposition Make:0 height:0 startTime:0 duration:totalDuration];
    [compostion setDuration:totalDuration];

    // 构造音频轨道
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"hoaprox" ofType:@"mp3"];
    TAVAudioAsset *asset = [TAVAudioAsset MakeFromPath:audioPath];
    TAVAudio *audio = [TAVAudio MakeFrom:asset startTime:0 duration:totalDuration];
    [audio setDuration:totalDuration];

    // 构造音频变换特效
    // 前3秒淡入，最后3秒淡出
    TAVAudioVolumeEffect *effect = [TAVAudioVolumeEffect MakeFIFOEffect:audio maxVolume:1.0f fadeInDuration:3 * 1000 * 1000
                                                        fadeOutDuration:3 * 1000 * 1000];
    // 注意，这边需要设置startTime 和 duration，保证和输入在同一个时间出现
    [effect setDuration:totalDuration];
    [compostion addClip:effect];
    return compostion;
}

@end
