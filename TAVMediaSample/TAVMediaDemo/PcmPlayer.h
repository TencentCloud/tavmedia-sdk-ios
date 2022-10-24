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
#import <AudioToolbox/AudioToolbox.h>

#import <TAVMedia/TAVAudioReader.h>

#define QUEUE_BUFFER_SIZE 4     //队列缓冲个数
#define AUDIO_BUFFER_SIZE 2048  //数据区大小
#define SAMPLE_RATE 44100
#define CHANNELS 1
#define MAX_BUFFER_SIZE 44100

@interface PcmPlayer : NSObject
@property (nonatomic, strong) TAVAudioReader *audioReader;

- (BOOL)start;
- (void)play:(NSData *)data;
- (void)stop;

@end
