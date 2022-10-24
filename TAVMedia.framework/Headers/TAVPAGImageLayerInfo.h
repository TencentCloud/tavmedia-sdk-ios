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

#import "TAVVideoRange.h"

/**
 * The basic infomation of PAGImageLayer with specified editableIndex.
 */
__attribute__((visibility("default")))
@interface TAVPAGImageLayerInfo : NSObject

/**
 * The layer's name of PAGImageLayer.
 */
@property (nonatomic, copy) NSString *layerName;

/**
 * The index of the array which contains layers with the same editableIndex.
 */
@property (nonatomic, assign) NSUInteger layerIndex;

/**
 * The start time of the layer in file's timeline.
 */
@property (nonatomic, assign) NSInteger layerStartTime;

/**
 * The duration of the layer.
 */
@property (nonatomic, assign) NSInteger layerDuration;

/**
 * Returns the content duration which indicates the minimal length required for
 * replacement.
 */
@property (nonatomic, assign) NSInteger contentDuration;

/**
 * The time ranges of the source video for replacement in the layer time range.
 */
@property (nonatomic, copy) NSArray<TAVVideoRange *> *displayVideoRanges;

@end
