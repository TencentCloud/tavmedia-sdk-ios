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

/**
 * Video export config, user can specify the width、height、outPath and if use hardware encoder.
 */
__attribute__((visibility("default")))
@interface TAVExportConfig : NSObject

/**
 * Default value is 720.
 */
@property (nonatomic, assign) NSInteger videoWidth;

/**
 * Default value is 1280.
 */
@property (nonatomic, assign) NSInteger videoHeight;

/**
 * Default value is 30.
 */
@property (nonatomic, assign) NSInteger frameRate;

/**
 * Default value is 8000000.
 */
@property (nonatomic, assign) NSInteger videoBitrateBps;

/**
 * Default value is 44100.
 */
@property (nonatomic, assign) NSInteger audioSampleRate;

/**
 * Default value is 2.
 */
@property (nonatomic, assign) NSInteger audioChannels;

/**
 * Default value is 128000.
 */
@property (nonatomic, assign) NSInteger audioBitrateBps;

@property (nonatomic, copy) NSString *outPath;

@end
