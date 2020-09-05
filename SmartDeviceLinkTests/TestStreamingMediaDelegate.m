//
//  TestStreamingMediaDelegate.m
//  SmartDeviceLinkTests
//
//  Created by Leonid Lokhmatov on 8/24/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import "TestStreamingMediaDelegate.h"
#import "SDLLogMacros.h"

@interface TestStreamingMediaDelegate ()
@property (nonatomic, strong) NSMutableArray *recordedSizesImp;
@end

@implementation TestStreamingMediaDelegate

- (instancetype)init {
    if ((self = [super init])) {
        _recordedSizesImp = [NSMutableArray arrayWithCapacity:8];
    }
    return self;
}

- (NSArray *)recordedSizes {
    return self.recordedSizesImp;
}

- (void)reset {
    [self.recordedSizesImp removeAllObjects];
}

#pragma mark - SDLStreamingMediaDelegate

- (void)videoManager:(id)manager didUpdateSize:(CGSize)displaySize {
    SDLLogD(@"SDLStreamingMediaDelegate didUpdateSize: %@", NSStringFromCGSize(displaySize));
    [self.recordedSizesImp addObject:[NSValue valueWithCGSize:displaySize]];
}

- (void)videoManagerDidStop:(id)manager {
    SDLLogD(@"SDLStreamingMediaDelegate videoManagerDidStop");
}

@end
