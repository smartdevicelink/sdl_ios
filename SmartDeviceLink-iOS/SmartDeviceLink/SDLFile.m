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

@property (copy, nonatomic, nullable) NSString *filePath;
@property (strong, nonatomic, readwrite) SDLFileType *fileType;

@property (assign, nonatomic) BOOL persistent;
@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSData *data;

@end


@implementation SDLFile

#pragma mark - Lifecycle

- (nullable instancetype)initWithFileAtPath:(NSString *)path {
    return [self initWithFileAtPath:path name:[[NSFileManager defaultManager] displayNameAtPath:path]];
}

- (instancetype)initWithData:(NSData *)data name:(NSString *)name type:(SDLFileType *)fileType {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _data = data;
    _name = name;
    _fileType = fileType;
    _persistent = NO;
    
    return self;
}

#pragma mark Private Lifecycle

- (instancetype)initWithFileAtPath:(NSString *)path name:(NSString *)name {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    BOOL pathExists = [[NSFileManager defaultManager] isReadableFileAtPath:path];
    if (!pathExists) {
        return nil;
    }
    
    _filePath = path;
    _name = name;
    _persistent = NO;
    _fileType = [self.class sdl_fileTypeFromFilePath:path];
    
    return self;
}


#pragma mark - Readonly Getters

- (NSData *)data {
    if (_data != nil) {
        return _data;
    } else if (_filePath != nil) {
        return [[NSFileManager defaultManager] contentsAtPath:_filePath];
    } else {
        return nil;
    }
}


#pragma mark - File Type

+ (SDLFileType *)sdl_fileTypeFromFilePath:(NSString *)filePath {
    NSString *fileExtension = filePath.pathExtension;
    
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
