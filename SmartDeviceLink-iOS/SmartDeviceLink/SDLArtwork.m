//
//  SDLArtwork.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/15/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLArtwork.h"

#import "SDLFileType.h"

@interface SDLArtwork ()

@property (strong, nonatomic) UIImage *image;

@end


@implementation SDLArtwork

#pragma mark - Lifecycle

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name asImageFormat:(SDLArtworkImageFormat)imageFormat {
    return [self initWithImage:image name:name persistent:NO asImageFormat:imageFormat];
}

- (instancetype)initWithPersistentImage:(UIImage *)image name:(NSString *)name asImageFormat:(SDLArtworkImageFormat)imageFormat {
    return [self initWithImage:image name:name persistent:YES asImageFormat:imageFormat];
}


#pragma Private Lifecycle

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name persistent:(BOOL)persistent asImageFormat:(SDLArtworkImageFormat)imageFormat {
    NSData *imageData = nil;
    SDLFileType *fileType = nil;
    
    switch (imageFormat) {
        case SDLArtworkImageFormatPNG: {
            imageData = UIImagePNGRepresentation(image);
            fileType = [SDLFileType GRAPHIC_PNG];
        } break;
        case SDLArtworkImageFormatJPG: {
            imageData = UIImageJPEGRepresentation(image, 0.85);
            fileType = [SDLFileType GRAPHIC_JPEG];
        } break;
    }
    
    return [super initWithData:imageData name:name type:fileType persistent:persistent];
}

@end
