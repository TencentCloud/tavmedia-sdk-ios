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

#import "TAVCutViewController.h"

@interface TAVCutViewController ()

@end

@implementation TAVCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (TAVComposition *)makeRootComposition {
    NSInteger totalDuration = 10 * 1000 * 1000;

    // 原始movie
    NSString *movieFilePath = [[NSBundle mainBundle] pathForResource:@"video-640x360" ofType:@"mp4"];
    TAVMovieAsset *asset = [TAVMovieAsset MakeFromPath:movieFilePath];
    TAVMovie *movie = [TAVMovie MakeFrom:asset startTime:0 duration:totalDuration];
    [movie setDuration:totalDuration];

#pragma mark 裁剪画面
    // movie 通过CropRect + matrix 显示一部分画面 并位移到正确位置
    // movie 会先应用matrix再应用cropRect，matrix是相对父composition的位置，cropRect是相对自己内容的裁剪区域
    TAVMovie *movieWithCropRectAndMatrix = [TAVMovie MakeFrom:asset startTime:0 duration:totalDuration];
    [movieWithCropRectAndMatrix setDuration:totalDuration];

    // 将锚点移动到0，0
    CGAffineTransform matrix = CGAffineTransformMakeTranslation(-asset.width / 2, -asset.height / 2);
    // 基于锚点拉伸两倍
    matrix = CGAffineTransformConcat(matrix, CGAffineTransformMakeScale(2.0, 2.0));
    // 恢复锚点位移
    matrix = CGAffineTransformConcat(matrix, CGAffineTransformMakeTranslation(asset.width / 2, asset.height / 2));
    // 移动到目标位置
    matrix = CGAffineTransformConcat(matrix, CGAffineTransformMakeTranslation(asset.width + 10, 0));
    // 裁剪后只剩下中间的一部分
    CGRect cropRect = CGRectMake(asset.width / 4, asset.height / 4, asset.width / 2, asset.height / 2);
    [movieWithCropRectAndMatrix setCropRect:cropRect];
    [movieWithCropRectAndMatrix setMatrix:matrix];

    // movie 只使用CropRect
    // movie 会先应用matrix再应用cropRect，matrix是相对父composition的位置，cropRect是相对自己内容的裁剪区域
    TAVMovie *movieWithCropRect = [TAVMovie MakeFrom:asset startTime:0 duration:totalDuration];
    [movieWithCropRect setDuration:totalDuration];
    [movieWithCropRect setCropRect:cropRect];
    [movieWithCropRect setMatrix:CGAffineTransformMakeTranslation(0, asset.height + 10)];

#pragma mark 裁剪时间
    // 通过Movie构造函数的startTime和duration，可以截取视频的其中一部分，注意：后续无法更改截取的范围
    // 从视频的1s开始播放，播放10s
    TAVMovie *movieWithTimeRange = [TAVMovie MakeFrom:asset startTime:1 * 1000 * 1000 duration:totalDuration];
    [movieWithTimeRange setDuration:totalDuration];
    [movieWithTimeRange setMatrix:CGAffineTransformMakeTranslation(asset.width + 10, asset.height + 10)];

    // Compostion也可以设置CropRect和Matrix，用法和Movie是一致的
    TAVComposition *composition = [TAVComposition Make:640 * 2 + 10 height:360 * 2 + 10 startTime:0 duration:totalDuration];

    [composition addClip:movie];
    [composition addClip:movieWithCropRectAndMatrix];
    [composition addClip:movieWithCropRect];
    [composition addClip:movieWithTimeRange];
    [composition setDuration:totalDuration];
    return composition;
}

@end
