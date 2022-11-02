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

#import "TAVProperty.h"

/**
 * The properties to transform the position.
 */
__attribute__((visibility("default")))
@interface TAVTransform2D : NSObject

/*
 * 缩放，旋转的锚点X
 */
@property (nonatomic, strong) TAVProperty *anchorPointX;

/*
 * 缩放，旋转的锚点Y
 */
@property (nonatomic, strong) TAVProperty *anchorPointY;

/*
 * 平移 X
 */
@property (nonatomic, strong) TAVProperty *translationX;

/*
 * 平移 Y
 */
@property (nonatomic, strong) TAVProperty *translationY;

/*
 * 缩放 X
 */
@property (nonatomic, strong) TAVProperty *scaleX;

/*
 * 缩放 Y
 */
@property (nonatomic, strong) TAVProperty *scaleY;

/*
 * 旋转单位：度(不是弧度)
 */
@property (nonatomic, strong) TAVProperty *rotation;

/*
 * 不透明度，0-全透，1-不透
 */
@property (nonatomic, strong) TAVProperty *opacity;

@end
