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
#import "TAVExportType.h"
#import "TAVExportErrorCode.h"
#import "TAVExportConfig.h"

/**
 * Export callback to notify progress and result.
 */
@protocol TAVMediaExportDelegate <NSObject>
@optional
- (void)onProgress:(TAVExportType)type progress:(CGFloat)progress;

- (void)onCompletion:(TAVExportType)type status:(NSDictionary<NSString *, NSString *> *)status;

- (void)onError:(TAVExportType)type errorCode:(TAVExportErrorCode)errorCode;

@end

__attribute__((visibility("default")))
@interface TAVExport : NSObject

/**
 * Create a Export with the specified media and export config.
 */
+ (instancetype)MakeMediaExport:(TAVMedia *)media config:(TAVExportConfig *)config delegate:(id<TAVMediaExportDelegate>)delegate;

/**
 * start to export media.
 */
- (void)exportMedia;

/**
 * cancel export media
 */
- (void)cancel;

/**
 * get export progress
 */
- (CGFloat)getProgress;

@end
