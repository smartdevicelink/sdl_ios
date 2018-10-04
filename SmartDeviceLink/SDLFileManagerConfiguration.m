//
//  SDLFileManagerConfiguration.m
//  SmartDeviceLink
//
//  Created by Nicole on 7/12/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLFileManagerConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

static NSUInteger const DefaultRetryCount = 1;

@implementation SDLFileManagerConfiguration

+ (instancetype)defaultConfiguration {
    return [[self.class alloc] initWithArtworkRetryCount:DefaultRetryCount fileRetryCount:DefaultRetryCount];
}

- (instancetype)initWithArtworkRetryCount:(UInt8)artworkRetryCount fileRetryCount:(UInt8)fileRetryCount {
    self = [super init];
    if (!self) {
        return nil;
    }

    _artworkRetryCount = artworkRetryCount;
    _fileRetryCount = fileRetryCount;

    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLFileManagerConfiguration *new = [[SDLFileManagerConfiguration allocWithZone:zone] initWithArtworkRetryCount:_artworkRetryCount fileRetryCount:_fileRetryCount];
    return new;
}

@end

NS_ASSUME_NONNULL_END
