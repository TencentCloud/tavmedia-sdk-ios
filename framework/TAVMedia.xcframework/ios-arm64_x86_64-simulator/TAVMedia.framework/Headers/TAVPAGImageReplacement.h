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

#import "TAVScaleMode.h"

__attribute__((visibility("default")))
@interface TAVPAGImageReplacement : NSObject

/**
 * Creates a TAVPAGImageReplacement object from a path of a image file, return null if the file does not exist or
 * it's not a valid image file.
 */
+ (instancetype)MakeFromPath:(NSString *)path;

/**
 * Creates a TAVPAGImageReplacement object from the index of effect's inputs.
 */
+ (instancetype)MakeFromInputIndex:(NSUInteger)inputIndex;

/**
 * The transformation will be applied to the image content. The scaleMode property
 * will be set to PAGScaleMode::None when matrix is set.
 */
@property (nonatomic, assign) CGAffineTransform matrix;

/**
 * Specifies the rule of how to scale the image content to fit the original image size. The matrix
 * changes when scaleMode is changed.
 */
@property (nonatomic, assign) TAVScaleMode scaleMode;

/**
 * Reset the matrix and scaleMode to original value.
 */
- (void)resetMatrix;

/**
 * Return the matrix or scaleMode has been changed.
 */
- (BOOL)hasChangedMatrix;

@end

