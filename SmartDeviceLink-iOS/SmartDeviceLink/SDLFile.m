//
//  SDLFile.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLFile.h"

#import "SDLFileType.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLFile ()

@property (copy, nonatomic, nullable) NSURL *fileURL;
@property (strong, nonatomic, readwrite) SDLFileType *fileType;

@property (assign, nonatomic, readwrite) BOOL persistent;
@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSData *data;

@end


@implementation SDLFile

#pragma mark - Lifecycle

- (instancetype)initWithURL:(NSURL *)url name:(NSString *)name persistent:(BOOL)persistent {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    BOOL exists = url.isFileURL && [url checkResourceIsReachableAndReturnError:nil];
    if (!exists) {
        return nil;
    }
    
    _fileURL = url;
    _name = name;
    _persistent = persistent;
    _fileType = [self.class sdl_fileTypeFromFileURL:url];
    
    return self;
}

+ (instancetype)persistentFileAtURL:(NSURL *)url name:(NSString *)name {
    return [[self alloc] initWithURL:url name:name persistent:YES];
}

+ (instancetype)ephemeralFileAtURL:(NSURL *)url name:(NSString *)name {
    return [[self alloc] initWithURL:url name:name persistent:NO];
}

- (instancetype)initWithData:(NSData *)data name:(NSString *)name type:(SDLFileType *)fileType persistent:(BOOL)persistent {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // TODO: Write to temp directory? Would have to delete after its sent, or cached?
    _data = data;
    _name = name;
    _fileType = fileType;
    _persistent = persistent;
    
    return self;
}

+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name type:(SDLFileType *)fileType persistent:(BOOL)persistent {
    return [[self alloc] initWithData:data name:name type:fileType persistent:persistent];
}


#pragma mark - Readonly Getters

- (NSData *)data {
    if (_data != nil) {
        return _data;
    } else if (_fileURL != nil) {
        return [NSData dataWithContentsOfURL:_fileURL];
    } else {
        return nil;
    }
}


#pragma mark - File Type

+ (SDLFileType *)sdl_fileTypeFromFileURL:(NSURL *)url {
    NSString *fileExtension = url.pathExtension;
    
    if ([fileExtension caseInsensitiveCompare:@"bmp"] == NSOrderedSame) {
        return [SDLFileType GRAPHIC_BMP];
    } else if (([fileExtension caseInsensitiveCompare:@"jpg"] == NSOrderedSame) ||
               ([fileExtension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame)) {
        return [SDLFileType GRAPHIC_JPEG];
    } else if ([fileExtension caseInsensitiveCompare:@"png"] == NSOrderedSame) {
        return [SDLFileType GRAPHIC_PNG];
    } else if ([fileExtension caseInsensitiveCompare:@"wav"] == NSOrderedSame) {
        return [SDLFileType AUDIO_WAVE];
    } else if ([fileExtension caseInsensitiveCompare:@"mp3"] == NSOrderedSame) {
        return [SDLFileType AUDIO_MP3];
    } else if ([fileExtension caseInsensitiveCompare:@"aac"] == NSOrderedSame) {
        return [SDLFileType AUDIO_AAC];
    } else if ([fileExtension caseInsensitiveCompare:@"json"] == NSOrderedSame) {
        return [SDLFileType JSON];
    } else {
        return [SDLFileType BINARY];
    }
}

@end

NS_ASSUME_NONNULL_END
