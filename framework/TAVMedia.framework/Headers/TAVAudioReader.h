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

#import <CoreMedia/CoreMedia.h>
#import "TAVClip.h"
#import "TAVMedia.h"

__attribute__((visibility("default")))
@interface TAVAudioFrame : NSObject
/**
 * The presentation time of this audio frame in microseconds. μs
 */
@property (nonatomic) int64_t timestamp;
/**
 * The duration of this audio frame in microseconds. μs
 */
@property (nonatomic) int64_t duration;
/**
 * Audio Frame Data
 */
@property (nonatomic, retain) NSData *data;
@end

__attribute__((visibility("default")))
@interface TAVAudioReader : NSObject

/**
 * Creates audio reader with a specified media and default option.
 * sampleRate = 44100
 * sampleCount = 1024
 * channels = 2
 */
+ (instancetype)MakeFrom:(TAVMedia *)media;

/**
 * Creates audio reader with a specified media and specified sampleRate, sampleCount and channels.
 */
+ (instancetype)MakeFrom:(TAVMedia *)media sampleRate:(NSInteger)sampleRate sampleCount:(NSInteger)sampleCount channels:(NSInteger)channels;
/**
 * Sets the current frame to the specified time.
 */
- (void)seekTo:(int64_t)time;

/**
 * Reads the next audio frame for the output.
 */
- (TAVAudioFrame *)readNextFrame;
@end
