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

#import <UIKit/UIKit.h>
#import "TAVAsset.h"
#import "TAVClip.h"
#import "TAVPAGEditableInfo.h"

__attribute__((visibility("default")))
@interface TAVMedia : TAVClip

/**
 * The current volume of this media, which is usually in the range [0 - 1.0].
 */
@property (nonatomic) CGFloat volume;
@end

__attribute__((visibility("default")))
@interface TAVAudio : TAVMedia
/**
 * Creates a new Audio from the specified time range of a asset. Returns nullptr if the asset is
 * empty or it has no audio output.
 */
+ (instancetype)MakeFrom:(TAVAsset *)asset startTime:(int64_t)startTime duration:(int64_t)duration;
@end

__attribute__((visibility("default")))
@interface TAVMovie : TAVMedia

/**
 * Creates a new Movie from the specified time range of an asset. Returns nullptr if the asset is
 * empty.
 */
+ (instancetype)MakeFrom:(TAVAsset *)asset startTime:(int64_t)startTime duration:(int64_t)duration;

/**
 * Creates a new Movie from the specified time ranges of an asset. Returns nullptr if the asset is
 * empty or ranges is empty.
 */
+ (instancetype)MakeFrom:(TAVAsset *)asset videoRanges:(NSArray<TAVVideoRange *> *)videoRanges;

/**
 * Creates a new Movie from the time ranges and content's offset of an asset. Returns nullptr if the asset is
 * empty or ranges is empty.
 * The ContentOffset affects where the content starts.
 */
+ (instancetype)MakeFrom:(TAVAsset *)asset videoRanges:(NSArray<TAVVideoRange *> *)videoRanges contentOffset:(int64_t)offset;

/**
 * Width of this movie.
 */
- (NSInteger)width;

/**
 * Height of this movie.
 */
- (NSInteger)height;

/**
 * Alpha value of this movie.The value of this property must be in the range 0.0
 * (transparent) to 1.0 (opaque). Values outside that range are clamped to the minimum or maximum.
 * The default value of this property is 1.0.
 */
@property (nonatomic) CGFloat opacity;

/**
 * Matrix specifies how this movie's video contents are positioned in
 * parent Composition.
 */
@property (nonatomic) CGAffineTransform matrix;

/**
 * CropRect specifies how this movie's video contents are cropped in parent
 * Composition.
 */
@property (nonatomic) CGRect cropRect;
@end

/**
 * An object that combines and arranges clips into a single composite clip that you can play or
 * process.
 */
__attribute__((visibility("default")))
@interface TAVComposition : TAVMovie

/**
 * Creates a Composition with specified width、height. The Composition's duration and content duration will match children duration.
 */
+ (instancetype)Make:(int64_t)width height:(int64_t)height;

/**
 * Creates a Composition with specified width、height、startTimeUs and durationUs.
 */
+ (instancetype)Make:(int64_t)width height:(int64_t)height startTime:(int64_t)startTime duration:(int64_t)duration;

/**
 * Creates a Composition from the json, return null if the json does not exist or it's
 * not a valid json object.
 */
+ (instancetype)MakeFromJson:(NSString *)json;

- (NSString *)toJson;

/**
 * Adds a clip to this composition.
 */
- (void)addClip:(TAVClip *)clip;

/**
 * Gets all clips from this composition.
 */
- (NSArray<TAVClip *> *)getAllClips;

/**
 * Removes a clip from this composition.
 */
- (void)removeClip:(TAVClip *)clip;

/**
 * Removes all clips from this composition.
 */
- (void)removeAllClips;
@end

/**
 * A sticker that display PAG file
 */
__attribute__((visibility("default")))
@interface TAVPAGSticker : TAVMovie

/**
 * Creates a PAGSticker object from the specified asset, return null if the asset is null or
 * it's not a valid asset.
 */
+ (instancetype)MakeFrom:(TAVPAGAsset *)asset;

/**
 * Creates a PAGSticker object from the specified asset, return null if the asset is null or
 * it's not a valid asset. User can specify the startTime、duration.
 */
+ (instancetype)MakeFrom:(TAVPAGAsset *)asset startTime:(int64_t)startTime duration:(int64_t)duration;

/**
 * Creates a PAGSticker object from the specified asset, return null if the asset is null or
 * it's not a valid asset. User can specify the startTime、duration and stretchDuration.
 */
+ (instancetype)MakeFrom:(TAVPAGAsset *)asset startTime:(int64_t)startTime duration:(int64_t)duration stretchDuration:(int64_t)stretchDuration;

/**
 * The number of replaceable images.
 */
- (int)numImages;

/**
 * The number of replaceable texts.
 */
- (int)numTexts;

/**
 * Replace the color of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex color:(UIColor *)color;

/**
 * Replace the image content of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex imagePath:(NSString *)imagePath;

/**
 * Replaces the image content of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex imagePath:(NSString *)imagePath scaleMode:(int)scaleMode;

/**
 * Replace the text data of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex text:(NSString *)text;

/**
 * Replace the text attributes of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex textAttribute:(TAVTextAttribute *)attribute;

/**
 * Returns the text attribute of the specified editable index.
 */
- (TAVTextAttribute *)getTextAttribute:(int)editableIndex;

/**
 * Returns an array of editable info that lie under the specified point. The point is in pixels and from
 * surface's coordinates.
 */
- (NSArray<TAVPAGEditableInfo *> *)getEditableInfoUnderSurfacePoint:(CGPoint)surfacePoint;
@end
