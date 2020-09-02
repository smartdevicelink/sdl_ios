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

@property (copy, nonatomic, readwrite, nullable) NSURL *fileURL;
@property (copy, nonatomic, readwrite) NSData *data;

@property (strong, nonatomic, readwrite) SDLFileType fileType;
@property (assign, nonatomic, readwrite) BOOL persistent;
@property (copy, nonatomic, readwrite) NSString *name;

@property (nonatomic, readwrite) NSInputStream *inputStream;

@property (assign, nonatomic, readwrite) BOOL isStaticIcon;

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
    _data = [NSData data];
    _name = name;
    _persistent = persistent;
    _fileType = [self.class sdl_fileTypeFromFileExtension:url.pathExtension];
    _overwrite = NO;

    return self;
}

+ (instancetype)persistentFileAtFileURL:(NSURL *)url name:(NSString *)name {
    return [[self alloc] initWithFileURL:url name:name persistent:YES];
}

+ (instancetype)fileAtFileURL:(NSURL *)url name:(NSString *)name {
    return [[self alloc] initWithFileURL:url name:name persistent:NO];
}

- (instancetype)initWithData:(NSData *)data name:(NSString *)name fileExtension:(NSString *)extension persistent:(BOOL)persistent {
    self = [super init];
    if (!self) {
        return nil;
    }
    if (data.length == 0) {
        return nil;
    }

    _fileURL = nil;
    _data = data;
    _name = name;
    _persistent = persistent;
    _fileType = [self.class sdl_fileTypeFromFileExtension:extension];
    _overwrite = NO;

    return self;
}

+ (instancetype)persistentFileWithData:(NSData *)data name:(NSString *)name fileExtension:(NSString *)extension {
    return [[self alloc] initWithData:data name:name fileExtension:extension persistent:YES];
}

+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name fileExtension:(NSString *)extension {
    return [[self alloc] initWithData:data name:name fileExtension:extension persistent:NO];
}

#pragma mark - Getters

- (NSData *)data {
    if (_data.length == 0 && _fileURL != nil) {
        return [NSData dataWithContentsOfURL:_fileURL];
    }

    return _data;
}

/**
 Initalizes a socket from which to read data.

 @discussion A new `NSInputStream` is created when requested instead of returning the already open `NSInputStream`. This is done because once a opened, a stream *cannot* be closed and reopened. If the same file is accessed multiple times (i.e. a non-persistant file is uploaded before and after a disconnect from Core during the same session) the file cannot be accessed after the first access because the stream is closed once the upload is completed. Apple `NSInputStream` doc: https://developer.apple.com/documentation/foundation/nsstream/1411963-open

 @return A socket
 */
- (NSInputStream *)inputStream {
    if (_fileURL) {
        // Data in file
        _inputStream = [[NSInputStream alloc] initWithURL:_fileURL];
    } else if (_data.length != 0) {
        // Data in memory
        _inputStream = [[NSInputStream alloc] initWithData:_data];
    }
    return _inputStream;
}

/**
 Gets the size of the data. The data may be stored on disk or it may already be in the application's memory.

 @return The size of the data.
 */
- (unsigned long long)fileSize {
    if (_fileURL) {
        // Data in file
        NSString *path = [_fileURL path];
        return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    } else if (_data) {
        // Data in memory
        return _data.length;
    }
    return 0;
}

#pragma mark - File Type

+ (SDLFileType)sdl_fileTypeFromFileExtension:(NSString *)fileExtension {
    if ([fileExtension caseInsensitiveCompare:@"bmp"] == NSOrderedSame) {
        return SDLFileTypeBMP;
    } else if (([fileExtension caseInsensitiveCompare:@"jpg"] == NSOrderedSame) ||
               ([fileExtension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame)) {
        return SDLFileTypeJPEG;
    } else if ([fileExtension caseInsensitiveCompare:@"png"] == NSOrderedSame) {
        return SDLFileTypePNG;
    } else if ([fileExtension caseInsensitiveCompare:@"wav"] == NSOrderedSame) {
        return SDLFileTypeWAV;
    } else if ([fileExtension caseInsensitiveCompare:@"mp3"] == NSOrderedSame) {
        return SDLFileTypeMP3;
    } else if ([fileExtension caseInsensitiveCompare:@"aac"] == NSOrderedSame) {
        return SDLFileTypeAAC;
    } else if ([fileExtension caseInsensitiveCompare:@"json"] == NSOrderedSame) {
        return SDLFileTypeJSON;
    } else {
        return SDLFileTypeBinary;
    }
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithFileURL:_fileURL name:_name persistent:_persistent];
}

#pragma mark - NSObject overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"SDLFile: %@", self.name];
}

- (NSUInteger)hash {
    return self.name.hash ^ self.data.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) { return YES; }

    if (![object isKindOfClass:[SDLFile class]]) { return NO; }

    return [self isEqualToFile:(SDLFile *)object];
}

- (BOOL)isEqualToFile:(SDLFile *)file {
    if (!file) { return NO; }

    BOOL haveEqualNames = [self.name isEqualToString:file.name];
    BOOL haveEqualData = [self.data isEqualToData:file.data];
    BOOL haveEqualFormats = [self.fileType isEqualToEnum:file.fileType];

    return haveEqualNames && haveEqualData && haveEqualFormats;
}

@end

NS_ASSUME_NONNULL_END
