//  SDLPutFile.m
//

#import "SDLPutFile.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

#import <zlib.h>

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPutFile

- (instancetype)init {
    if (self = [super initWithName:SDLNamePutFile]) {
    }
    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.syncFileName = fileName;
    self.fileType = fileType;

    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile {
    self = [self initWithFileName:fileName fileType:fileType];
    if (!self) {
        return nil;
    }

    self.persistentFile = @(persistentFile);

    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length {
    self = [self initWithFileName:fileName fileType:fileType persistentFile:persistentFile];
    if (!self) {
        return nil;
    }

    self.systemFile = @(systemFile);
    self.offset = @(offset);
    self.length = @(length);

    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length crc:(UInt64)crc {
    self = [self initWithFileName:fileName fileType:fileType persistentFile:persistentFile];
    if (!self) {
        return nil;
    }

    self.systemFile = @(systemFile);
    self.offset = @(offset);
    self.length = @(length);
    self.crc = crc == 0 ? nil : @(crc);

    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length bulkData:(NSData *)bulkData {

    self = [self initWithFileName:fileName fileType:fileType persistentFile:persistentFile systemFile:systemFile offset:offset length:length crc:[self.class sdl_getCRC32ChecksumForBulkData:bulkData]];
    if (!self) {
        return nil;
    }

    self.bulkData = bulkData;

    return self;
}

#pragma mark - Getters and Setters

- (void)setSyncFileName:(NSString *)syncFileName {
    [parameters sdl_setObject:syncFileName forName:SDLNameSyncFileName];
}

- (NSString *)syncFileName {
    return [parameters sdl_objectForName:SDLNameSyncFileName];
}

- (void)setFileType:(SDLFileType)fileType {
    [parameters sdl_setObject:fileType forName:SDLNameFileType];
}

- (SDLFileType)fileType {
    return [parameters sdl_objectForName:SDLNameFileType];
}

- (void)setPersistentFile:(nullable NSNumber<SDLBool> *)persistentFile {
    [parameters sdl_setObject:persistentFile forName:SDLNamePersistentFile];
}

- (nullable NSNumber<SDLBool> *)persistentFile {
    return [parameters sdl_objectForName:SDLNamePersistentFile];
}

- (void)setSystemFile:(nullable NSNumber<SDLBool> *)systemFile {
    [parameters sdl_setObject:systemFile forName:SDLNameSystemFile];
}

- (nullable NSNumber<SDLBool> *)systemFile {
    return [parameters sdl_objectForName:SDLNameSystemFile];
}

- (void)setOffset:(nullable NSNumber<SDLUInt> *)offset {
    [parameters sdl_setObject:offset forName:SDLNameOffset];
}

- (nullable NSNumber<SDLUInt> *)offset {
    return [parameters sdl_objectForName:SDLNameOffset];
}

- (void)setLength:(nullable NSNumber<SDLUInt> *)length {
    [parameters sdl_setObject:length forName:SDLNameLength];
}

- (nullable NSNumber<SDLUInt> *)length {
    return [parameters sdl_objectForName:SDLNameLength];
}

- (void)setCrc:(nullable NSNumber<SDLUInt> *)crc {
    [parameters sdl_setObject:crc forName:SDLNameCRC];
}

- (nullable NSNumber<SDLUInt> *)crc {
    return [parameters sdl_objectForName:SDLNameCRC];
}

#pragma mark - Helpers

+ (unsigned long)sdl_getCRC32ChecksumForBulkData:(NSData *)data {
    if (data.length == 0) {
        return 0;
    }

    return crc32(0, data.bytes, (uInt)data.length);
}

@end

NS_ASSUME_NONNULL_END
