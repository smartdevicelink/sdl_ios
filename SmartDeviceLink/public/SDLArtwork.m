//
//  SDLArtwork.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/15/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "SDLArtwork.h"
#import "SDLFileType.h"
#import "SDLImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFile ()

@property (assign, nonatomic, readwrite) BOOL isStaticIcon;

@end

@interface SDLArtwork ()

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic, readwrite) BOOL isTemplate;

@end


@implementation SDLArtwork

#pragma mark - Lifecycle

+ (instancetype)artworkWithImage:(UIImage *)image name:(NSString *)name asImageFormat:(SDLArtworkImageFormat)imageFormat {
    return [[self alloc] initWithImage:image name:name persistent:NO asImageFormat:imageFormat];
}

+ (instancetype)artworkWithImage:(UIImage *)image asImageFormat:(SDLArtworkImageFormat)imageFormat {
    return [[self alloc] initWithImage:image persistent:NO asImageFormat:imageFormat];
}

+ (instancetype)artworkWithStaticIcon:(SDLStaticIconName)staticIcon {
    return [[self alloc] initWithStaticIcon:staticIcon];
}

+ (instancetype)persistentArtworkWithImage:(UIImage *)image name:(NSString *)name asImageFormat:(SDLArtworkImageFormat)imageFormat {
    return [[self alloc] initWithImage:image name:name persistent:YES asImageFormat:imageFormat];
}

+ (instancetype)persistentArtworkWithImage:(UIImage *)image asImageFormat:(SDLArtworkImageFormat)imageFormat {
    return [[self alloc] initWithImage:image persistent:YES asImageFormat:imageFormat];
}


#pragma mark Private Lifecycle

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name persistent:(BOOL)persistent asImageFormat:(SDLArtworkImageFormat)imageFormat {
    self.image = image;
    return [super initWithData:[self.class sdl_dataForUIImage:image imageFormat:imageFormat] name:name fileExtension:[self.class sdl_fileExtensionForImageFormat:imageFormat] persistent:persistent];
}

- (instancetype)initWithImage:(UIImage *)image persistent:(BOOL)persistent asImageFormat:(SDLArtworkImageFormat)imageFormat {
    self.image = image;
    NSData *imageData = [self.class sdl_dataForUIImage:image imageFormat:imageFormat];
    NSString *imageName = [self.class sdl_md5HashFromNSData:imageData];
    return [super initWithData:[self.class sdl_dataForUIImage:image imageFormat:imageFormat] name:(imageName != nil ? imageName : @"") fileExtension:[self.class sdl_fileExtensionForImageFormat:imageFormat] persistent:persistent];
}

- (instancetype)initWithStaticIcon:(SDLStaticIconName)staticIcon {
    self = [super initWithData:[staticIcon dataUsingEncoding:NSASCIIStringEncoding] name:staticIcon fileExtension:@"" persistent:NO];
    self.isStaticIcon = true;

    return self;
}

#pragma mark - Setters and Getters

- (void)setImage:(UIImage *)image {
    _image = image;
    _isTemplate = (image.renderingMode == UIImageRenderingModeAlwaysTemplate);
}

- (SDLImage *)imageRPC {
    if (self.isStaticIcon) {
        return [[SDLImage alloc] initWithStaticIconName:self.name];
    } else {
        return [[SDLImage alloc] initWithName:self.name isTemplate:self.isTemplate];
    }
}

#pragma mark - Helper Methods

/**
 * Returns the JPG or PNG image data for a UIImage.
 *
 *  @param image        A UIImage
 *  @param imageFormat  The image format to use when converting the UIImage to NSData
 *  @return             The image data
 */
+ (NSData *)sdl_dataForUIImage:(UIImage *)image imageFormat:(SDLArtworkImageFormat)imageFormat {
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

/**
 *  Returns the file extension for the image format.
 *
 *  @param imageFormat  Whether the image is a PNG or JPG
 *  @return             The file extension for the image format
 */
+ (NSString *)sdl_fileExtensionForImageFormat:(SDLArtworkImageFormat)imageFormat {
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

/**
 *  Creates a string representation of NSData by hashing the data using the MD5 hash function. This string is not guaranteed to be unique as collisions can occur, however collisions are extremely rare.
 *
 *  HAX: A MD5 hash always creates a string with 32 characters (128-bits). Due to some implementations of Core not following the spec, file names that are too long are being rejected. To try to accommodate this setup, hashed file names are being truncated to 16 characters.
 *
 *  Sourced from https://stackoverflow.com/questions/2018550/how-do-i-create-an-md5-hash-of-a-string-in-cocoa
 *
 *  @param data     The data to hash
 *  @return         A MD5 hash of the data
 */
+ (NSString *)sdl_md5HashFromNSData:(NSData *)data {
    if (data == nil) { return nil; }

    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (CC_LONG)[data length], hash);
    NSMutableString *formattedHash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    // HAX: To shorten the string to 16 characters, the loop has been shortened to 8 fom 16.
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH / 2; i += 1) {
        [formattedHash appendFormat:@"%02x", hash[i]];
    }
    return formattedHash;
}

#pragma mark - NSObject overrides

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLArtworkImageFormat imageFormat = self.fileType == SDLFileTypePNG ? SDLArtworkImageFormatPNG : SDLArtworkImageFormatJPG;

    return [[SDLArtwork allocWithZone:zone] initWithImage:[self.image copy] name:[self.name copy] persistent:self.isPersistent asImageFormat:imageFormat];
}

- (NSUInteger)hash {
    return self.name.hash ^ self.data.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) { return YES; }

    if (![object isKindOfClass:[SDLArtwork class]]) { return NO; }

    return [self isEqualToArtwork:(SDLArtwork *)object];
}

- (BOOL)isEqualToArtwork:(SDLArtwork *)artwork {
    if (!artwork) { return NO; }

    BOOL haveEqualNames = [self.name isEqualToString:artwork.name];
    BOOL haveEqualData = [self.data isEqualToData:artwork.data];
    BOOL haveEqualFormats = [self.fileType isEqualToEnum:artwork.fileType];

    return haveEqualNames && haveEqualData && haveEqualFormats;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SDLArtwork name: %@, image: %@, isTemplate: %@, isStaticIcon: %@", self.name, self.image, (self.isTemplate ? @"YES" : @"NO"), (self.isStaticIcon ? @"YES" : @"NO")];
}

@end

NS_ASSUME_NONNULL_END
