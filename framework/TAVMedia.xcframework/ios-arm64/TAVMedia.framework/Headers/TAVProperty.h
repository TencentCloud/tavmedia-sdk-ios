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

typedef enum {
    KeyframeInterpolationTypeNone = 0,
    KeyframeInterpolationTypeLinear = 1,
    KeyframeInterpolationTypeBezier = 2,
    KeyframeInterpolationTypeHold = 3,
} TAVKeyframeInterpolationType;

/**
 * Create different type of bezier curve.
 */
__attribute__((visibility("default")))
@interface TAVKeyFrame : NSObject

+ (instancetype)MakeLinear:(NSInteger)startTime endTime:(NSInteger)endTime startValue:(NSNumber *)startValue endValue:(NSNumber *)endValue;

+ (instancetype)MakeHold:(NSInteger)startTime endTime:(NSInteger)endTime startValue:(NSNumber *)startValue endValue:(NSNumber *)endValue;

+ (instancetype)MakeBezier:(NSInteger)startTime
                   endTime:(NSInteger)endTime
                startValue:(NSNumber *)startValue
                  endValue:(NSNumber *)endValue
                 bezierOut:(CGPoint)bezierOut
                  bezierIn:(CGPoint)bezierIn;

@property (nonatomic, retain) NSNumber *startValue;
@property (nonatomic, retain) NSNumber *endValue;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) TAVKeyframeInterpolationType interpolationType;

// 贝塞尔曲线使用(0,0),(1,1)作为起始点和结束点，控制点位，先求出比例，再根据startValue和endValue换算差值
- (CGPoint)bezierOut;

- (CGPoint)bezierIn;

@end

__attribute__((visibility("default")))
@interface TAVProperty : NSObject

@property (nonatomic, retain) NSNumber *value;

@end

__attribute__((visibility("default")))
@interface TAVAnimatableProperty : TAVProperty

@property (nonatomic, retain) NSArray<TAVKeyFrame *> *keyframes;

@end
