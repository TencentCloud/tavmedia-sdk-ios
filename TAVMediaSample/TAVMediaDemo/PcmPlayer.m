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

#import "PcmPlayer.h"

#import <AVFoundation/AVFoundation.h>

static void sAudioQueueOutputCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer);

@interface PcmPlayer () {
    NSCondition *mAudioLock;
    AudioQueueRef mAudioPlayer;
    AudioQueueBufferRef mAudioBufferRef[QUEUE_BUFFER_SIZE];
    void *mPCMData;
    int mDataLen;
}
@end

@implementation PcmPlayer

const AudioStreamBasicDescription inFormat
    = { SAMPLE_RATE, kAudioFormatLinearPCM, kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked, 2, 1, 2, 1, 16, 0 };

- (BOOL)start {
    mPCMData = malloc(MAX_BUFFER_SIZE);
    mAudioLock = [[NSCondition alloc] init];

    AudioQueueNewOutput(&inFormat, sAudioQueueOutputCallback, (__bridge void *)(self), nil, nil, 0, &mAudioPlayer);

    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        AudioQueueAllocateBuffer(mAudioPlayer, AUDIO_BUFFER_SIZE, &mAudioBufferRef[i]);
        memset(mAudioBufferRef[i]->mAudioData, 0, AUDIO_BUFFER_SIZE);
        mAudioBufferRef[i]->mAudioDataByteSize = AUDIO_BUFFER_SIZE;
        AudioQueueEnqueueBuffer(mAudioPlayer, mAudioBufferRef[i], 0, NULL);
    }

    AudioQueueSetParameter(mAudioPlayer, kAudioQueueParam_Volume, 1.0);
    AudioQueueStart(mAudioPlayer, NULL);
    return YES;
}

- (void)play:(NSData *)data {
    [mAudioLock lock];
    int len = (int)[data length];
    if (len > 0 && len + mDataLen < MAX_BUFFER_SIZE) {
        memcpy(mPCMData + mDataLen, [data bytes], [data length]);
        mDataLen += AUDIO_BUFFER_SIZE;
    }
    [mAudioLock unlock];
}

- (void)stop {
    AudioQueueStop(mAudioPlayer, YES);
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        AudioQueueFreeBuffer(mAudioPlayer, mAudioBufferRef[i]);
    }
    AudioQueueDispose(mAudioPlayer, YES);

    free(mPCMData);
    mPCMData = nil;
    mAudioPlayer = nil;
    mAudioLock = nil;
}

- (void)handlerOutputAudioQueue:(AudioQueueRef)inAQ inBuffer:(AudioQueueBufferRef)inBuffer {
    BOOL hasSend = NO;
    while (!hasSend) {
        if (mDataLen >= AUDIO_BUFFER_SIZE) {
            [mAudioLock lock];
            memcpy(inBuffer->mAudioData, mPCMData, AUDIO_BUFFER_SIZE);
            mDataLen -= AUDIO_BUFFER_SIZE;
            memmove(mPCMData, mPCMData + AUDIO_BUFFER_SIZE, mDataLen);
            [mAudioLock unlock];
            hasSend = YES;
        } else {
            if (_audioReader) {
                TAVAudioFrame *frame = [_audioReader readNextFrame];
                [self play:frame.data];
            }
        }
    }

    inBuffer->mAudioDataByteSize = AUDIO_BUFFER_SIZE;
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}
@end

static void sAudioQueueOutputCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
    PcmPlayer *player = (__bridge PcmPlayer *)(inUserData);
    [player handlerOutputAudioQueue:inAQ inBuffer:inBuffer];
}
