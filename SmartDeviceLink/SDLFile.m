//
//  SDLFile.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLFile.h"

#import "SDLFileManager.h"
#import "SDLFileType.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLFile ()

@property (copy, nonatomic, readwrite) NSURL *fileURL;
@property (strong, nonatomic, readwrite) SDLFileType *fileType;

@property (assign, nonatomic, readwrite) BOOL persistent;
@property (copy, nonatomic, readwrite) NSString *name;

@end


@implementation SDLFile

#pragma mark - Lifecycle

- (instancetype)initWithFileURL:(NSURL *)url name:(NSString *)name persistent:(BOOL)persistent {
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
    _fileType = [self.class sdl_fileTypeFromFileExtension:url.pathExtension];
    _overwrite = NO;
    
    return self;
}

+ (instancetype)persistentFileAtFileURL:(NSURL *)url name:(NSString *)name {
    return [[self alloc] initWithFileURL:url name:name persistent:YES];
}

+ (instancetype)ephemeralFileAtFileURL:(NSURL *)url name:(NSString *)name {
    return [[self alloc] initWithFileURL:url name:name persistent:NO];
}

- (instancetype)initWithData:(NSData *)data name:(NSString *)name fileExtension:(NSString *)extension persistent:(BOOL)persistent {
    if (data.length == 0) { return nil; }
    
    // TODO: Only flush to file URL when under memory pressure? Most of the time this won't be needed
    NSError *error = nil;
    NSString *tempFileName = [NSString stringWithFormat:@"%@_%@.%@", [NSProcessInfo processInfo].globallyUniqueString, name, extension];
    NSURL *fileURL = [[SDLFileManager temporaryFileDirectory] URLByAppendingPathComponent:tempFileName];
    [data writeToURL:_fileURL options:NSDataWritingAtomic error:&error];
    if (error) {
        return nil;
    }
    
    return [self initWithFileURL:fileURL name:name persistent:persistent];
}

+ (instancetype)persistentFileWithData:(NSData *)data name:(NSString *)name fileExtension:(NSString *)extension {
    return [[self alloc] initWithData:data name:name fileExtension:extension persistent:YES];
}

+ (instancetype)ephemeralFileWithData:(NSData *)data name:(NSString *)name fileExtension:(NSString *)extension {
    return [[self alloc] initWithData:data name:name fileExtension:extension persistent:NO];
}


#pragma mark - Readonly Getters

- (NSData *)data {
    return [NSData dataWithContentsOfURL:_fileURL];
}


#pragma mark - File Type

+ (SDLFileType *)sdl_fileTypeFromFileExtension:(NSString *)fileExtension {
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


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithFileURL:_fileURL name:_name persistent:_persistent];
}

@end

NS_ASSUME_NONNULL_END
