//
//  SDLMsgVersion.h
//  SmartDeviceLink
//
//  Created by Justin Gluck on 7/18/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * Specifies the version number of the SDL V4 interface. This is used by both the application and SDL to declare what interface version each is using.
 *
 * @since SDL 1.0
 */
@interface SDLMsgVersion : SDLRPCStruct

/**
 *  Convenience init with a version string
 *
 *  @param versionString A version string in the following format: @"majorVersion.minorVersion.patchVersion" Example: @"6.0.0"
 *  @return A SDLMsgVersion object
*/
+ (instancetype)versionWithString:(NSString *)versionString;

/**
 *  Convenience init for all parameters.
 *
 *  @param majorVersion         Major version
 *  @param minorVersion         Minor version
 *  @param patchVersion         Patch version
 *  @return                     A SDLMsgVersion object
 */
- (instancetype)initWithMajorVersion:(UInt8)majorVersion minorVersion:(UInt8)minorVersion patchVersion:(UInt8)patchVersion;

/**
 * The major version indicates versions that is not-compatible to previous versions
 *
 * Required, Integer, 1 - 10
 */
@property (strong, nonatomic) NSNumber<SDLInt> *majorVersion;

/**
 * The minor version indicates a change to a previous version that should still allow to be run on an older version (with limited functionality)
 *
 * Required, Integer, 0 - 1000
 */
@property (strong, nonatomic) NSNumber<SDLInt> *minorVersion;

/**
 * Allows backward-compatible fixes to the API without increasing the minor version of the interface
 *
 * Optional, Integer, 0 - 1000
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *patchVersion;

@end

NS_ASSUME_NONNULL_END
