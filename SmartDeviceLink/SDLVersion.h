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

/// Specifies the version number of the SmartDeviceLink protocol that is supported by the mobile application.
@interface SDLVersion : NSObject <NSCopying>

/// Major version
@property (nonatomic, assign) NSUInteger major;

/// Minor version
@property (nonatomic, assign) NSUInteger minor;

/// Patch version
@property (nonatomic, assign) NSUInteger patch;

/// A String format of the current SDLVersion
@property (nonatomic, copy, readonly) NSString *stringVersion;

/// Convenience init
///
/// @param major Major version
/// @param minor Minor version
/// @param patch Patch version
/// @return An SDLVersion object
- (instancetype)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor patch:(NSUInteger)patch;

/// Convenience init
///
/// @param major Major version
/// @param minor Minor version
/// @param patch Patch version
/// @return An SDLVersion object
+ (instancetype)versionWithMajor:(NSUInteger)major minor:(NSUInteger)minor patch:(NSUInteger)patch;

/// Convenience init
///
/// @param versionString String representation of the version
/// @return An SDLVersion object
- (nullable instancetype)initWithString:(NSString *)versionString;

/// Convenience init
///
/// @param versionString String representation of the version
/// @return An SDLVersion object
+ (nullable instancetype)versionWithString:(NSString *)versionString;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
/// Deprecated convenience init to set version using SDLSyncMsgVersion
///
/// @param syncMsgVersion Specifies the version number of the SmartDeviceLink protocol that is supported by the mobile application.
/// @return An SDLVersion object
- (instancetype)initWithSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion __deprecated_msg(("Use initWithSDLMsgVersion:sdlMsgVersion: instead"));

/// Deprecated convenience init to set version using SDLSyncMsgVersion
///
/// @param syncMsgVersion Specifies the version number of the SmartDeviceLink protocol that is supported by the mobile application.
/// @return An SDLVersion object
+ (instancetype)versionWithSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion __deprecated_msg(("Use versionWithSDLMsgVersion:sdlMsgVersion instead"));
#pragma clang diagnostic pop

/// Convenience init to set version using SDLMsgVersion
///
/// @param sdlMsgVersion Specifies the version number of the SmartDeviceLink protocol that is supported by the mobile application.
/// @return
- (instancetype)initWithSDLMsgVersion:(SDLMsgVersion *)sdlMsgVersion;

/// Convenience init to set version using SDLMsgVersion
///
/// @param sdlMsgVersion Specifies the version number of the SmartDeviceLink protocol that is supported by the mobile application.
/// @return
+ (instancetype)versionWithSDLMsgVersion:(SDLMsgVersion *)sdlMsgVersion;

- (NSComparisonResult)compare:(SDLVersion *)otherVersion;

/// Compare is less than
///
/// @param otherVersion SDLVersion Object
/// @return BOOL
- (BOOL)isLessThanVersion:(SDLVersion *)otherVersion;

/// Compare is equal to
///
/// @param otherVersion SDLVersion Object
/// @return BOOL
- (BOOL)isEqualToVersion:(SDLVersion *)otherVersion;

/// Compare is greater than
///
/// @param otherVersion SDLVersion Object
/// @return BOOL
- (BOOL)isGreaterThanVersion:(SDLVersion *)otherVersion;

/// Compare is greater than or equal to
///
/// @param otherVersion SDLVersion Object
/// @return BOOL
- (BOOL)isGreaterThanOrEqualToVersion:(SDLVersion *)otherVersion;

/// Compare is less than or equal to
///
/// @param otherVersion SDLVersion Object
/// @return BOOL
- (BOOL)isLessThanOrEqualToVersion:(SDLVersion *)otherVersion;

@end

NS_ASSUME_NONNULL_END
