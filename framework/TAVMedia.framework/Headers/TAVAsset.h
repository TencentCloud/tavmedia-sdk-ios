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

__attribute__((visibility("default")))
@interface TAVAsset : NSObject

/**
 * Returns the duration of this asset.
 */
- (int64_t)duration;

/**
 * Returns true if this asset has audio output.
 */
- (BOOL)hasAudio;

/**
 * Returns true if this asset has video output.
 */
- (BOOL)hasVideo;

/**
 * Returns the width of this asset.
 */
- (CGFloat)width;

/**
 * Returns the height of this asset.
 */
- (CGFloat)height;

@end

__attribute__((visibility("default")))
@interface TAVImageAsset : TAVAsset

/**
 * Creates a ImageAsset from the specified image file path. return nullptr if the file does not
 * exist or it's not a valid image file.
 */
+ (instancetype)MakeFromPath:(NSString *)path;

/**
 * Creates a new ImageAsset from the specified file bytes, return null if the bytes is empty or
 * it's not a valid image file.
 */
+ (instancetype)MakeFromData:(NSData *)data;

@end

__attribute__((visibility("default")))
@interface TAVMovieAsset : TAVAsset

/**
 * Creates a MovieAsset object from the specified movie file bytes, return null if the bytes is
 * empty or it's not a valid movie file.
 */
+ (instancetype)MakeFromPath:(NSString *)path;

/**
 * Creates a MovieAsset object from a specified movie file path, return null if the file
 * does not exist or it's not a valid video file.
 */
+ (instancetype)MakeFromData:(NSData *)data;

/**
 * Returns the frame rate of the asset.
 */
- (CGFloat)frameRate;

@end

__attribute__((visibility("default")))
@interface TAVAudioAsset : TAVAsset

/**
 * Creates a AudioAsset object from a specified audio file path, return null if the file does
 * not exist or it's not a valid audio file.
 */
+ (instancetype)MakeFromPath:(NSString *)path;
@end

__attribute__((visibility("default")))
@interface TAVPAGAsset : TAVAsset

/**
 * Creates a PAGAsset object from a specified pag file path, return null if the file does
 * not exist or it's not a valid pag file.
 */
+ (instancetype)MakeFromPath:(NSString *)path;
@end
