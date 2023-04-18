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

__attribute__((visibility("default")))
@interface TAVFont : NSObject

/**
 * A string with the name of the font family.
 **/
@property (nonatomic, copy) NSString *fontFamily;

/**
 * A string with the style information — e.g., “bold”, “italic”.
 **/
@property (nonatomic, copy) NSString *fontStyle;

+ (instancetype)RegisterFont:(NSString *)fontPath;

+ (instancetype)RegisterFont:(NSString *)fontPath family:(NSString *)fontFamily style:(NSString *)fontStyle;

+ (instancetype)RegisterFont:(void *)data size:(size_t)length;

+ (instancetype)RegisterFont:(void *)data size:(size_t)length family:(NSString *)fontFamily style:(NSString *)fontStyle;

+ (void)UnregisterFont:(TAVFont *)font;

@end
