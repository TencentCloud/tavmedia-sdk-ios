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

__attribute__((visibility("default")))
@interface TAVSurface : NSObject

/**
 * Creates a new TAVSurface from specified CAEAGLLayer. The GPU context will be created internally
 * by PAGSurface.
 */
+ (instancetype)FromLayer:(CAEAGLLayer *)layer;

/**
 * Creates a new TAVSurface from specified CVPixelBuffer. The GPU context will be created internally
 * by PAGSurface.
 */
+ (instancetype)FromCVPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/**
 * Creates a new TAVSurface from specified CVPixelBuffer and EAGLContext. Multiple TAVSurface with
 * the same context share the same GPU caches. The caches are not destroyed when resetting a
 * TAVVideoReader's surface to another TAVSurface with the same context.
 */
+ (instancetype)FromCVPixelBuffer:(CVPixelBufferRef)pixelBuffer context:(EAGLContext *)eaglContext;

/**
 * The width of surface in pixels.
 */
- (int)width;

/**
 * The height of surface in pixels.
 */
- (int)height;

/**
 * Update the size of surface, and reset the internal surface.
 */
- (void)updateSize;

/**
 * Erases all pixels of this surface with transparent color. Returns true if the content has
 * changed.
 */
- (BOOL)clearAll;

/**
 * Free the cache created by the surface immediately. Can be called to reduce memory pressure.
 */
- (void)freeCache;

/**
 * Returns the CVPixelBuffer object created by MakeFromGPU.
 */
- (CVPixelBufferRef)getCVPixelBuffer;

@end
