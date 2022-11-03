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

#import "TAVMedia.h"
#import "TAVScaleMode.h"
#import "TAVSurface.h"

__attribute__((visibility("default")))
@interface TAVVideoReader : NSObject

/**
 * Creates video reader with a specified media and specified fps.
 */
+ (instancetype)MakeFrom:(TAVMedia *)media frameRate:(NSInteger)frameRate;

/**
 * Set the TAVSurface object for TAVVideoReader to render onto.
 */
- (void)setSurface:(TAVSurface *)surface;

/**
 * Sets the current frame to the specified time.
 */
- (void)seekTo:(int64_t)time;

/**
 * Reads the next video frame for the output.
 */
- (void)readNextFrame;

/**
 * Returns the current scale mode.
 */
- (TAVScaleMode)scaleMode;

/**
 * Specifies the rule of how to scale the content to fit the surface size. The matrix
 * changes when this method is called.
 */
- (void)setScaleMode:(TAVScaleMode)mode;

/**
 * Returns a copy of current matrix.
 */
- (CGAffineTransform)matrix;

/**
 * Set the transformation which will be applied to the composition. The scaleMode property
 * will be set to TAVScaleMode::None when this method is called.
 */
- (void)setMatrix:(CGAffineTransform)matrix;

- (NSArray<TAVClip *> *)getClipsUnderPoint:(CGPoint)point;
@end
