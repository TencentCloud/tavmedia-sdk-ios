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

#import "TAVGeneratorViewController.h"
#import <TAVMedia/TAVVideoReader.h>
#import <TAVMedia/TAVSurface.h>

#pragma mark - TAVSnapshotsGenerator
@interface TAVSnapshotsGenerator ()

@property (weak, nonatomic) id<TAVGeneratorDelegate> delegate;

@property (copy, nonatomic) NSArray<NSNumber *> *timepoints;

@property (strong, nonatomic) TAVVideoReader *videoReader;

@property (strong, nonatomic) TAVSurface *surface;

@property (assign, nonatomic) dispatch_queue_t delegateQueue;

@property (assign, atomic) BOOL running;

@end

@implementation TAVSnapshotsGenerator

+ (instancetype)MakeGenerator:(TAVMovie *)movie timepoints:(NSArray<NSNumber *> *)timepoints {
    if (movie == nil || timepoints == nil || timepoints.count == 0) {
        return nil;
    }
    TAVVideoReader *videoReader = [TAVVideoReader MakeFrom:movie frameRate:30];
    if (videoReader == nil) {
        return nil;
    }
    // 这边最好把movie的matrix重置一下，防止movie在截图器中的位置不正确
    if (!CGAffineTransformIsIdentity(movie.matrix)) {
        NSLog(@"Matrix of movie %@ isn't identity", movie);
    }
    // 通过pixelbuffer创建离屏的surface，后续内容会绘制到pixelBuffer上
    CVPixelBufferRef pixelBuffer = [self createPixelBuffer:movie.width height:movie.height];
    TAVSurface *surface = [TAVSurface FromCVPixelBuffer:pixelBuffer];
    if (surface == nil) {
        return nil;
    }
    [videoReader setSurface:surface];
    TAVSnapshotsGenerator *generator = [[TAVSnapshotsGenerator alloc] init];
    generator.videoReader = videoReader;
    generator.surface = surface;
    generator.timepoints = timepoints;
    return generator;
}

- (void)setDelegate:(id<TAVGeneratorDelegate>)delegate {
    [self setDelegate:delegate queue:dispatch_get_main_queue()];
}

- (void)setDelegate:(id<TAVGeneratorDelegate>)delegate queue:(dispatch_queue_t)queue {
    _delegate = delegate;
    _delegateQueue = queue;
}

- (void)start {
    if (_delegate == nil) {
        return;
    }
    if (self.running) {
        return;
    }
    self.running = YES;
    __weak id weakSelf = self;
    // 启动异步线程进行数据加载，防止主线程卡顿
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        __strong TAVSnapshotsGenerator *strongSelf = weakSelf;
        for (NSNumber *timepoint in strongSelf.timepoints) {
            if (!self.running) {
                return;
            }
            // 通过调用seek定位到对应时间，之后调用readNextFrame将画面渲染到surface上
            [strongSelf.videoReader seekTo:timepoint.longLongValue];
            [strongSelf.videoReader readNextFrame];
            // 将surface转换成UIImage并发送到delegate队列
            UIImage *frame = [TAVSnapshotsGenerator pixelBufferToImage:strongSelf.surface.getCVPixelBuffer];
            dispatch_async(strongSelf.delegateQueue, ^{
                __strong TAVSnapshotsGenerator *strongSelf = weakSelf;
                [strongSelf.delegate didCreateSnapshot:frame timepoint:timepoint];
                if (timepoint == strongSelf.timepoints.lastObject) {
                    if ([strongSelf.delegate respondsToSelector:@selector(didFinish)]) {
                        [strongSelf.delegate didFinish];
                    }
                    strongSelf.running = NO;
                }
            });
        }
    });
}

- (void)cancel {
    self.running = NO;
}

+ (CVPixelBufferRef)createPixelBuffer:(NSInteger)width height:(NSInteger)height {
    if (width == 0 || height == 0) {
        return nil;
    }
    CFDictionaryRef empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFMutableDictionaryRef attrs
        = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(attrs, kCVPixelBufferIOSurfacePropertiesKey, empty);
    CVPixelBufferRef pixelBuffer = nil;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, attrs, &pixelBuffer);
    CFRelease(attrs);
    CFRelease(empty);
    if (status != kCVReturnSuccess) {
        return nil;
    }
    CFAutorelease(pixelBuffer);
    return pixelBuffer;
}

+ (UIImage *)pixelBufferToImage:(CVPixelBufferRef)pixelBuffer {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage =
        [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];

    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return uiImage;
}

@end

#pragma mark - TAVGeneratorViewController

@interface TAVGeneratorViewController () <UITableViewDataSource, TAVGeneratorDelegate>

@property (weak, nonatomic) IBOutlet UITableView *snapshotsView;

@property (strong, nonatomic) NSMutableArray<UIImage *> *snapshots;

@property (strong, nonatomic) TAVSnapshotsGenerator *generator;

@end

@implementation TAVGeneratorViewController

- (TAVMovie *)generatorMovie {
    TAVAsset *asset = [TAVMovieAsset MakeFromPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"]];
    TAVMovie *movie = [TAVMovie MakeFrom:asset startTime:0 duration:asset.duration];
    [movie setDuration:asset.duration];
    return movie;
}

- (void)initSnapshots {
    self.snapshots = [NSMutableArray array];
    TAVMovie *movie = [self generatorMovie];
    NSMutableArray *timepoints = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        [timepoints addObject:@(i * 1000 * 1000)];
        [self.snapshots addObject:[[UIImage alloc] init]];
    }
    self.generator = [TAVSnapshotsGenerator MakeGenerator:movie timepoints:timepoints];
    [self.generator setDelegate:self];
    [self.generator start];
    [self.snapshotsView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.snapshotsView.dataSource = self;
    [self initSnapshots];
}

- (void)dealloc {
    [self.generator cancel];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.snapshots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = self.snapshots[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"timepoint: %ld", indexPath.row * 1000 * 1000];
    return cell;
}

#pragma mark - TAVGeneratorDelegate

- (void)didCreateSnapshot:(UIImage *)snapshot timepoint:(NSNumber *)timepoint {
  if (timepoint.longLongValue == 0) {
    for (NSUInteger i = 0; i < self.snapshots.count; i ++) {
      self.snapshots[i] = snapshot;
    }
  } else {
    self.snapshots[timepoint.longLongValue / (1000 * 1000)] = snapshot;
  }
    
    [self.snapshotsView reloadData];
}

- (void)didFinish {
    self.generator = nil;
}

@end
