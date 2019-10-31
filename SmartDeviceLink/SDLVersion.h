//
//  SDLVersion.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/19/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLSyncMsgVersion;
@class SDLMsgVersion;

NS_ASSUME_NONNULL_BEGIN

@interface SDLVersion : NSObject <NSCopying>

/// Major version
@property (nonatomic, assign) NSUInteger major;

/// Minor version
@property (nonatomic, assign) NSUInteger minor;

/// Patch version
@property (nonatomic, assign) NSUInteger patch;

/// A String format of the current SDLVersion
@property (nonatomic, copy, readonly) NSString *stringVersion;

- (instancetype)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor patch:(NSUInteger)patch;
+ (instancetype)versionWithMajor:(NSUInteger)major minor:(NSUInteger)minor patch:(NSUInteger)patch;
- (nullable instancetype)initWithString:(NSString *)versionString;
+ (nullable instancetype)versionWithString:(NSString *)versionString;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (instancetype)initWithSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion __deprecated_msg(("Use initWithSDLMsgVersion:sdlMsgVersion: instead"));
+ (instancetype)versionWithSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion __deprecated_msg(("Use versionWithSDLMsgVersion:sdlMsgVersion instead"));
#pragma clang diagnostic pop
- (instancetype)initWithSDLMsgVersion:(SDLMsgVersion *)sdlMsgVersion;
+ (instancetype)versionWithSDLMsgVersion:(SDLMsgVersion *)sdlMsgVersion;

- (NSComparisonResult)compare:(SDLVersion *)otherVersion;
- (BOOL)isLessThanVersion:(SDLVersion *)otherVersion;
- (BOOL)isEqualToVersion:(SDLVersion *)otherVersion;
- (BOOL)isGreaterThanVersion:(SDLVersion *)otherVersion;
- (BOOL)isGreaterThanOrEqualToVersion:(SDLVersion *)otherVersion;
- (BOOL)isLessThanOrEqualToVersion:(SDLVersion *)otherVersion;

@end

NS_ASSUME_NONNULL_END
