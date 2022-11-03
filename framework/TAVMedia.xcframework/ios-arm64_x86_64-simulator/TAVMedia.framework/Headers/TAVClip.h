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

#import <Foundation/Foundation.h>

__attribute__((visibility("default")))
@interface TAVClip : NSObject

/**
 * The start time of this clip in the composition's timeline
 */
@property (nonatomic) int64_t startTime;

/**
 * The duration of this clip in the composition's timeline.
 */
@property (nonatomic) int64_t duration;

/**
 * Returns true if this clip has audio output.
 */
- (BOOL)hasAudio;

/**
 * Returns true if this clip has video output.
 */
- (BOOL)hasVideo;
@end
