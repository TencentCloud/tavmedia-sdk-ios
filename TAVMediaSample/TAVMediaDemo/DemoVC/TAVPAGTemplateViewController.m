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

#import "TAVPAGTemplateViewController.h"

#import <TAVMedia/TAVEffect.h>

@interface TAVPAGTemplateViewController ()

@end

@implementation TAVPAGTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray<TAVAsset *> *)createResoureAsset:(NSUInteger)size {
    // 这里是创建资源数组，按照业务逻辑创建即可
    NSArray<TAVAsset *> *pathArray = @[
        [TAVMovieAsset MakeFromPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"]],
        [TAVMovieAsset MakeFromPath:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp4"]],
        [TAVMovieAsset MakeFromPath:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"mp4"]],
        [TAVImageAsset MakeFromPath:[[NSBundle mainBundle] pathForResource:@"hermione" ofType:@"jpg"]],
        [TAVMovieAsset MakeFromPath:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"mp4"]]
    ];
    NSMutableArray<TAVAsset *> *result = [NSMutableArray arrayWithCapacity:size];
    while (result.count < size) {
      uint32_t rand = arc4random();
      [result addObject:pathArray[rand % pathArray.count]];
    }
    return result;
}

- (TAVComposition *)makeRootComposition {
    // 1.加载PAG文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"pag"];
    TAVPAGEffect *effect = [TAVPAGEffect MakeFrom:path];
    [effect setDuration:effect.fileDuration];

    // 2.获取所有PAG可替换图片的信息
    NSArray<TAVPAGEditableInfo *> *editableImgInfo = [effect getEditableInfoWithType:TAVPAGEditableTypeImage];
    
    // 3.构建一个容器，能够容纳PAG模板轨道和视频/图片轨道
    TAVComposition *composition = [TAVComposition Make:effect.width height:effect.height];

    // 4.加载视频、图片资源
    NSArray<TAVAsset *> * resourceAsset = [self createResoureAsset:editableImgInfo.count];

    NSInteger inputIndex = 0;
    NSInteger resourceIndex = 0;
    for (TAVPAGEditableInfo *info in editableImgInfo) {
        TAVPAGImageEditableInfo *imgInfo = (TAVPAGImageEditableInfo *)info;
        for (TAVPAGImageLayerInfo *layerInfo in imgInfo.layerInfo) {
            // 5.基于每个图层的VideoRanges信息，创建对应的视频轨道/图片轨道
            NSArray<TAVVideoRange *> *videoRanges = layerInfo.displayVideoRanges;
            TAVMovie *movie = [TAVMovie MakeFrom:resourceAsset[resourceIndex] videoRanges:videoRanges];
            [movie setStartTime:layerInfo.layerStartTime];
            // 将movie添加到composition中
            [composition addClip:movie];
            // 添加movie作为效果输入，同时替换layer对应的图层
            [effect addInput:movie];
            TAVPAGImageReplacement *replacement = [TAVPAGImageReplacement MakeFromInputIndex:inputIndex++];
            [effect replace:(int)info.editableIndex imageReplacement:replacement layerIndexes:@[@(layerInfo.layerIndex)]];
        }
        resourceIndex++;
    }

    // 5.添加effect
    [composition addClip:effect];
    return composition;
}

@end
