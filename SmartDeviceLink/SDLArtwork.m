//
//  SDLArtwork.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/15/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLArtwork.h"
#import "SDLFileType.h"
#import <CommonCrypto/CommonDigest.h>

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
    return [super initWithData:[self dataForUIImage:image imageFormat:imageFormat] name:name fileExtension:[self fileExtensionForImageFormat:imageFormat] persistent:persistent];
}

- (instancetype)initWithImage:(UIImage *)image persistent:(BOOL)persistent asImageFormat:(SDLArtworkImageFormat)imageFormat {
    NSData *imageData = [self dataForUIImage:image imageFormat:imageFormat];
    return [super initWithData:[self dataForUIImage:image imageFormat:imageFormat] name:[self md5HashFromNSData:imageData] fileExtension:[self fileExtensionForImageFormat:imageFormat] persistent:persistent];
}

- (NSData *)dataForUIImage:(UIImage *)image imageFormat:(SDLArtworkImageFormat)imageFormat {
    NSData *imageData = nil;
    switch (imageFormat) {
        case SDLArtworkImageFormatPNG: {
            imageData = UIImagePNGRepresentation(image);
        } break;
        case SDLArtworkImageFormatJPG: {
            imageData = UIImageJPEGRepresentation(image, 0.85);
        } break;
    }
    return imageData;
}

- (NSString *)fileExtensionForImageFormat:(SDLArtworkImageFormat)imageFormat {
    NSString *fileExtension = nil;
    switch (imageFormat) {
        case SDLArtworkImageFormatPNG: {
            fileExtension = @"png";
        } break;
        case SDLArtworkImageFormatJPG: {
            fileExtension = @"jpg";
        } break;
    }
    return fileExtension;
}

- (NSString *)md5HashFromNSData:(NSData *)data {
    if (data == nil) { return @""; }

    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (CC_LONG)[data length], hash);
    NSMutableString *formattedHash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i += 1) {
        [formattedHash appendFormat:@"%02x", hash[i]];
    }
    return formattedHash;
}

@end

NS_ASSUME_NONNULL_END
