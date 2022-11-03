#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CocoaUtils.h"
#import "TAVAsset.h"
#import "TAVAudioReader.h"
#import "TAVClip.h"
#import "TAVColorTuning.h"
#import "TAVCustomEffect.h"
#import "TAVEffect.h"
#import "TAVExport.h"
#import "TAVExportConfig.h"
#import "TAVExportErrorCode.h"
#import "TAVExportType.h"
#import "TAVLicense.h"
#import "TAVMedia.h"
#import "TAVPAGEditableInfo.h"
#import "TAVPAGImageLayerInfo.h"
#import "TAVPAGImageReplacement.h"
#import "TAVProperty.h"
#import "TAVScaleMode.h"
#import "TAVSurface.h"
#import "TAVTextAttribute.h"
#import "TAVTimeStretchMode.h"
#import "TAVTransform2D.h"
#import "TAVVideoDecoder.h"
#import "TAVVideoRange.h"
#import "TAVVideoReader.h"

FOUNDATION_EXPORT double TAVMediaVersionNumber;
FOUNDATION_EXPORT const unsigned char TAVMediaVersionString[];

