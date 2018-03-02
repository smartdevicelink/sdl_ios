//
//  SDLArtwork.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/15/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLFile.h"

typedef NS_ENUM(NSUInteger, SDLArtworkImageFormat) {
    SDLArtworkImageFormatPNG,
    SDLArtworkImageFormatJPG
};

NS_ASSUME_NONNULL_BEGIN

@interface SDLArtwork : SDLFile

/**
 *  Convenience Helper to create an ephemeral artwork from an image.
 *
 *  This is an ephemeral file, it will not be persisted through sessions / ignition cycles. Any files that you do not *know* you will use in future sessions should be created through this method. For example, album / artist artwork should be ephemeral.
 *
 *  Persistent files should be created using `persistentArtworkWithImage:name:asImageFormat:`
 *
 *  @warning It is strongly recommended to pass the file url using an SDLFile initializer instead of the image. If you pass the UIImage, it is loaded into memory, and will be dumped to a temporary file. This will create a duplicate file. *Only pass a UIImage if the image is not stored on disk*.
 *
 *  @param image       The UIImage to be sent to the remote head unit
 *  @param name        The name of the file that will be used to reference the file in the future (for example on the remote file system). The max file name length may vary based on remote file system limitations.
 *  @param imageFormat Whether the image should be converted to a PNG or JPG before transmission. Images with transparency or few colors should be PNGs. Images with many colors should be JPGs.
 *
 *  @return An instance of this class to be passed to the file manager.
 */
+ (instancetype)artworkWithImage:(UIImage *)image name:(NSString *)name asImageFormat:(SDLArtworkImageFormat)imageFormat NS_SWIFT_UNAVAILABLE("Use the standard initializer and set persistant to false");

/**
 *  Convenience Helper to create an ephemeral artwork from an image. A unique name will be assigned to the image. This name is a string representation of the image's data which is created by hashing the data using the MD5 algorithm.
 *
 *  This is an ephemeral file, it will not be persisted through sessions / ignition cycles. Any files that you do not *know* you will use in future sessions should be created through this method. For example, album / artist artwork should be ephemeral.
 *
 *  Persistent files should be created using `persistentArtworkWithImage:name:asImageFormat:`
 *
 *  @warning It is strongly recommended to pass the file url using an SDLFile initializer instead of the image. If you pass the UIImage, it is loaded into memory, and will be dumped to a temporary file. This will create a duplicate file. *Only pass a UIImage if the image is not stored on disk*.
 *
 *  @param image       The UIImage to be sent to the remote head unit
 *  @param imageFormat Whether the image should be converted to a PNG or JPG before transmission. Images with transparency or few colors should be PNGs. Images with many colors should be JPGs.
 *
 *  @return An instance of this class to be passed to the file manager.
 */
+ (instancetype)artworkWithImage:(UIImage *)image asImageFormat:(SDLArtworkImageFormat)imageFormat NS_SWIFT_UNAVAILABLE("Use the standard initializer and set persistant to false");

/**
 *  Convenience Helper to create a persistent artwork from an image.
 *
 *  This is a persistent file, it will be persisted through sessions / ignition cycles. You will only have a limited space for all files, so be sure to only persist files that are required for all or most sessions. For example, menu artwork should be persistent.
 *
 *  Ephemeral files should be created using `ephemeralArtworkWithImage:name:asImageFormat:`
 *
 *  @warning It is strongly recommended to pass the file url using an SDLFile initializer instead of the image. If you pass the UIImage, it is loaded into memory, and will be dumped to a temporary file. This will create a duplicate file. *Only pass a UIImage if the image is not stored on disk*.
 *
 *  @param image       The UIImage to be sent to the remote head unit
 *  @param name        The name of the file that will be used to reference the file in the future (for example on the remote file system). The max file name length may vary based on remote file system limitations.
 *  @param imageFormat Whether the image should be converted to a PNG or JPG before transmission. Images with transparency or few colors should be PNGs. Images with many colors should be JPGs.
 *
 *  @return An instance of this class to be passed to the file manager.
 */
+ (instancetype)persistentArtworkWithImage:(UIImage *)image name:(NSString *)name asImageFormat:(SDLArtworkImageFormat)imageFormat NS_SWIFT_UNAVAILABLE("Use the standard initializer and set persistant to true");

/**
 *  Convenience Helper to create a persistent artwork from an image. A unique name will be assigned to the image. This name is a string representation of the image's data which is created by hashing the data using the MD5 algorithm.
 *
 *  This is a persistent file, it will be persisted through sessions / ignition cycles. You will only have a limited space for all files, so be sure to only persist files that are required for all or most sessions. For example, menu artwork should be persistent.
 *
 *  Ephemeral files should be created using `ephemeralArtworkWithImage:name:asImageFormat:`
 *
 *  @warning It is strongly recommended to pass the file url using an SDLFile initializer instead of the image. If you pass the UIImage, it is loaded into memory, and will be dumped to a temporary file. This will create a duplicate file. *Only pass a UIImage if the image is not stored on disk*.
 *
 *  @param image       The UIImage to be sent to the remote head unit
 *  @param imageFormat Whether the image should be converted to a PNG or JPG before transmission. Images with transparency or few colors should be PNGs. Images with many colors should be JPGs.
 *
 *  @return An instance of this class to be passed to the file manager.
 */
+ (instancetype)persistentArtworkWithImage:(UIImage *)image asImageFormat:(SDLArtworkImageFormat)imageFormat NS_SWIFT_UNAVAILABLE("Use the standard initializer and set persistant to true");

/**
 *  Create a file for transmission to the remote system from a UIImage.
 *
 *  @param image       The UIImage to be sent to the remote head unit
 *  @param name        The name of the file that will be used to reference the file in the future (for example on the remote file system). The max file name length may vary based on remote file system limitations.
 *  @param persistent  Whether or not the artwork should be persistent.
 *  @param imageFormat Whether the image should be converted to a PNG or JPG before transmission. Images with transparency or few colors should be PNGs. Images with many colors should be JPGs.
 *
 *  @return An instance of this class to be passed to the file manager.
 */
- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name persistent:(BOOL)persistent asImageFormat:(SDLArtworkImageFormat)imageFormat;

/**
 *  Create a file for transmission to the remote system from a UIImage. A unique name will be assigned to the image. This name is a string representation of the image's data which is created by hashing the data using the MD5 algorithm.

 *  @param image       The UIImage to be sent to the remote head unit
 *  @param persistent  Whether or not the artwork should be persistent.
 *  @param imageFormat Whether the image should be converted to a PNG or JPG before transmission. Images with transparency or few colors should be PNGs. Images with many colors should be JPGs.
 *
 *  @return An instance of this class to be passed to the file manager.
 */
- (instancetype)initWithImage:(UIImage *)image persistent:(BOOL)persistent asImageFormat:(SDLArtworkImageFormat)imageFormat;

@end

NS_ASSUME_NONNULL_END
