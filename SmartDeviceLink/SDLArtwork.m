//
//  SDLArtwork.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/15/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLArtwork.h"

#import "SDLFileType.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLArtwork ()

@property (strong, nonatomic) UIImage *image;

@end


@implementation SDLArtwork

#pragma mark - Lifecycle

+ (instancetype)artworkWithImage:(UIImage *)image name:(NSString *)name asImageFormat:(SDLArtworkImageFormat)imageFormat {
    return [[self alloc] initWithImage:image name:name persistent:NO asImageFormat:imageFormat];
}

+ (instancetype)persistentArtworkWithImage:(UIImage *)image name:(NSString *)name asImageFormat:(SDLArtworkImageFormat)imageFormat {
    return [[self alloc] initWithImage:image name:name persistent:YES asImageFormat:imageFormat];
}


#pragma mark Private Lifecycle

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name persistent:(BOOL)persistent asImageFormat:(SDLArtworkImageFormat)imageFormat {
    NSData *imageData = nil;
    NSString *fileExtension = nil;

    switch (imageFormat) {
        case SDLArtworkImageFormatPNG: {
            imageData = UIImagePNGRepresentation(image);
            fileExtension = @"png";
        } break;
        case SDLArtworkImageFormatJPG: {
            imageData = UIImageJPEGRepresentation(image, 0.85);
            fileExtension = @"jpg";
        } break;
    }

    return [super initWithData:imageData name:name fileExtension:fileExtension persistent:persistent];
}

@end

NS_ASSUME_NONNULL_END
