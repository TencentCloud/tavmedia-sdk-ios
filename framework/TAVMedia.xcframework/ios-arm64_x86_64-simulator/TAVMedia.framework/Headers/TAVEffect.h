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
#import "TAVClip.h"
#import "TAVColorTuning.h"
#import "TAVPAGEditableInfo.h"
#import "TAVScaleMode.h"
#import "TAVTimeStretchMode.h"
#import "TAVTransform2D.h"
#import "TAVPAGImageReplacement.h"

__attribute__((visibility("default")))
@interface TAVEffect : TAVClip

/**
 * Adds a clip as one input source.
 */
- (void)addInput:(TAVClip *)clip;

/**
 * Removes the specified clip from input sources.
 */
- (void)removeInput:(TAVClip *)clip;

/**
 * Removes all clips from input sources.
 */
- (void)removeAllInputs;
@end

__attribute__((visibility("default")))
@interface TAVTransformEffect : TAVEffect

+ (instancetype)Make:(TAVTransform2D *)transform;

- (void)updateTransform:(TAVTransform2D *)transform;

@end

/**
 * Color Tuning Effect to change video color.
 */
__attribute__((visibility("default")))
@interface TAVColorTuningEffect : TAVEffect

/**
 * Creates a TAVColorTuningEffect with the specified TAVColorTuning property.
 */
+ (instancetype)Make:(TAVColorTuning *)colorTuning;

/**
 * Update the specified TAVColorTuning property
 */
- (void)updateColorTuning:(TAVColorTuning *)colorTuning;

@end

/**
 * The effect to add lut filter to video frame.
 */
__attribute__((visibility("default")))
@interface TAVLUTEffect : TAVEffect

/**
 * Creates a TAVLUTEffect with the specified lut file path.
 */
+ (instancetype)Make:(NSString *)lutPath;

/**
 * Set the filter strength.
 */
- (void)setStrength:(float)strength;

/**
 * Set the lut file path.
 */
- (void)setLutPath:(NSString *)lutPath;

@end

/**
 * The effect to make a matte with the specified chroma.
 */
__attribute__((visibility("default")))
@interface TAVChromaMattingEffect : TAVEffect

+ (instancetype)Make:(float)intensity shadow:(float)shadow selectedColor:(UIColor *)selectedColor;

- (void)updateConfig:(float)intensity shadow:(float)shadow selectedColor:(UIColor *)selectedColor;

@end

/**
 * A effect that display PAG file
 */
__attribute__((visibility("default")))
@interface TAVPAGEffect : TAVEffect

/**
 * Creates a PAGSticker object from the specified file path, return null if the file does not
 * exist or it's not a valid image file.
 */
+ (TAVPAGEffect *)MakeFrom:(NSString *)path;

/**
 * The number of replaceable images.
 */
- (int)numImages;

/**
 * The number of replaceable texts.
 */
- (int)numTexts;

/**
 * Returns the file duration of this effect.
 */
- (NSInteger)fileDuration;

/**
 * Returns the width of this asset.
 */
- (int)width;

/**
 * Returns the height of this asset.
 */
- (int)height;

/**
 * Replace the image content of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex inputIndex:(size_t)inputIndex;

/**
 * Replace the image content of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex inputIndex:(size_t)inputIndex matrix:(CGAffineTransform)matrix;

/**
 * Replace the image content of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex inputIndex:(size_t)inputIndex scaleMode:(TAVScaleMode)scaleMode;

/**
 * Replace the image content of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex imagePath:(NSString *)imagePath;

/**
 * Replace the image content of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex imagePath:(NSString *)imagePath matrix:(CGAffineTransform)matrix;

/**
 * Replace the image content of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex imagePath:(NSString *)imagePath scaleMode:(TAVScaleMode)scaleMode;

/**
 * Replace the image content of the image replacement.
 */
- (BOOL)replace:(int)editableIndex imageReplacement:(TAVPAGImageReplacement *)replacement;

/**
 * Replace the specified layers' image content of the image replacement.
 */
- (BOOL)replace:(int)editableIndex imageReplacement:(TAVPAGImageReplacement *)replacement layerIndexes:(NSArray<NSNumber *> *)indexes;

/**
 * Replace the text content of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex text:(NSString *)text;

/**
 * Replace the text attributes of the specified layer index.
 */
- (BOOL)replace:(int)editableIndex textAttribute:(TAVPAGTextAttribute *)attribute;

/**
 * Replace the layer matrix of the specified layer name.
 */
- (BOOL)replaceLayer:(NSString *)layerName matrix:(CGAffineTransform)matrix;

/**
 * Set the matrix of this effect.
 */
- (void)setMatrix:(CGAffineTransform)matrix;

/**
 * Returns a copy of current matrix.
 */
- (CGAffineTransform)matrix;

/**
 * Set the time stretch mode of this effect.
 */
- (void)setTimeStretchMode:(TAVTimeStretchMode)timeStretchMode;

/**
 * Returns the time stretch mode of this effect.
 */
- (TAVTimeStretchMode)timeStretchMode;

/**
 * Set the alpha of this effect.
 */
- (void)setAlpha:(CGFloat)alpha;

/**
 * Returns the alpha of this effect.
 */
- (CGFloat)alpha;

/**
 * Returns the text attribute of the specified editable index.
 */
- (TAVPAGTextAttribute *)getTextAttribute:(int)editableIndex;

/**
 * Returns an array of editable info that lie under the specified point. The point is in pixels and from
 * surface's coordinates.
 */
- (NSArray<TAVPAGEditableInfo *> *)getEditableInfoUnderSurfacePoint:(CGPoint)surfacePoint;

/**
 * Returns an array of editable info with the specified layer name.
 */
- (NSArray<TAVPAGEditableInfo *> *)getLayerEditableInfoWithName:(NSString *)layerName;

/**
 * Returns an array of editable info with the specified type.
 */
- (NSArray<TAVPAGEditableInfo *> *)getEditableInfoWithType:(TAVPAGEditableType)type;

@end

/**
 * Effect changes audio volume.
 */
__attribute__((visibility("default")))
@interface TAVAudioVolumeEffect : TAVEffect

/**
 * Creates a fade in and fade out AudioVolumeEffect.
 */
+ (instancetype)MakeFIFOEffect:(TAVClip *)clip
                     maxVolume:(CGFloat)maxVolume
                fadeInDuration:(NSInteger)fadeInDuration
               fadeOutDuration:(NSInteger)fadeOutDuration;

/**
 * Creates Audio Effect with the specified clip and keyframe list.
 */
+ (instancetype)MakeVolumeEffect:(TAVClip *)clip volumeRampList:(NSArray<TAVKeyFrame *> *)volumeRampList;

@end
