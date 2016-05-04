//
//  SDLArtwork.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/15/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

@import UIKit;

#import "SDLFile.h"

typedef NS_ENUM(NSUInteger, SDLArtworkImageFormat) {
    SDLArtworkImageFormatPNG,
    SDLArtworkImageFormatJPG
};

NS_ASSUME_NONNULL_BEGIN

@interface SDLArtwork : SDLFile

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name asImageFormat:(SDLArtworkImageFormat)imageFormat;
- (instancetype)initWithPersistentImage:(UIImage *)image name:(NSString *)name asImageFormat:(SDLArtworkImageFormat)imageFormat;

@end

NS_ASSUME_NONNULL_END