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

#import "TAVPAGTextAttribute.h"
#import "TAVPAGImageLayerInfo.h"

typedef enum {
    // Content that can be replaced by the replaceText method
    TAVPAGEditableTypeText = 0,
    // Content that can be replaced by the replaceImage method
    TAVPAGEditableTypeImage = 1

} TAVPAGEditableType;

/**
 * Editable info with specified index.
 */
__attribute__((visibility("default")))
@interface TAVPAGEditableInfo : NSObject

/**
 * The type of info.
 */
@property (assign, nonatomic, readonly) TAVPAGEditableType type;

/**
 * Editable index of info in PAGFile.
 */
@property (assign, nonatomic) NSInteger editableIndex;

@end

/**
 * Editable info with specified index of image.
 */
__attribute__((visibility("default")))
@interface TAVPAGImageEditableInfo : TAVPAGEditableInfo

/**
 * An array of PAGImageLayer's basic info.
 */
@property (copy, nonatomic) NSArray<TAVPAGImageLayerInfo *> *layerInfo;

@end

/**
 * Editable info with specified index of text.
 */
__attribute__((visibility("default")))
@interface TAVPAGTextEditableInfo : TAVPAGEditableInfo

/**
 * The raw text attributes of specified index.
 */
@property (strong, nonatomic) TAVPAGTextAttribute *attribute;

@end
