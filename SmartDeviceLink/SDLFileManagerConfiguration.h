//
//  SDLFileManagerConfiguration.h
//  SmartDeviceLink
//
//  Created by Nicole on 7/12/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSNumber+NumberType.h"

NS_ASSUME_NONNULL_BEGIN

/// File manager configuration information
@interface SDLFileManagerConfiguration : NSObject <NSCopying>

/**
 *  Defines the number of times the file manager will attempt to reupload `SDLArtwork` files in the event of a failed upload to Core.
 *
 *  Defaults to 1. To disable reuploads, set to 0.
 */
@property (assign, nonatomic) UInt8 artworkRetryCount;

/**
 *  Defines the number of times the file manager will attempt to reupload general `SDLFile`s in the event of a failed upload to Core.
 *
 *  Defaults to 1. To disable reuploads, set to 0.
 */
@property (assign, nonatomic) UInt8 fileRetryCount;

/**
 *  Creates a default file manager configuration.
 *
 *  @return A default configuration that may be customized.
 */
+ (instancetype)defaultConfiguration;

/**
 Use `defaultConfiguration` instead
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Creates a file manager configuration with customized upload retry counts.
 *
 *  @return The configuration
 */
- (instancetype)initWithArtworkRetryCount:(UInt8)artworkRetryCount fileRetryCount:(UInt8)fileRetryCount;

@end

NS_ASSUME_NONNULL_END
