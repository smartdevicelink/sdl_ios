//  SDLPutFile.m
//

#import "SDLPutFile.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPutFile

- (instancetype)init {
    if (self = [super initWithName:SDLNamePutFile]) {
    }
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

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile {
    self = [self initWithFileName:fileName fileType:fileType];
    if (!self) {
        return nil;
    }

    self.persistentFile = @(persistentFile);

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

- (void)setSyncFileName:(NSString *)syncFileName {
    if (syncFileName != nil) {
        [parameters setObject:syncFileName forKey:SDLNameSyncFileName];
    } else {
        [parameters removeObjectForKey:SDLNameSyncFileName];
    }
}

- (NSString *)syncFileName {
    return [parameters objectForKey:SDLNameSyncFileName];
}

- (void)setFileType:(SDLFileType)fileType {
    if (fileType != nil) {
        [parameters setObject:fileType forKey:SDLNameFileType];
    } else {
        [parameters removeObjectForKey:SDLNameFileType];
    }
}

- (SDLFileType)fileType {
    NSObject *obj = [parameters objectForKey:SDLNameFileType];
    return (SDLFileType)obj;
}

- (void)setPersistentFile:(nullable NSNumber<SDLBool> *)persistentFile {
    if (persistentFile != nil) {
        [parameters setObject:persistentFile forKey:SDLNamePersistentFile];
    } else {
        [parameters removeObjectForKey:SDLNamePersistentFile];
    }
}

- (nullable NSNumber<SDLBool> *)persistentFile {
    return [parameters objectForKey:SDLNamePersistentFile];
}

- (void)setSystemFile:(nullable NSNumber<SDLBool> *)systemFile {
    if (systemFile != nil) {
        [parameters setObject:systemFile forKey:SDLNameSystemFile];
    } else {
        [parameters removeObjectForKey:SDLNameSystemFile];
    }
}

- (nullable NSNumber<SDLBool> *)systemFile {
    return [parameters objectForKey:SDLNameSystemFile];
}

- (void)setOffset:(nullable NSNumber<SDLUInt> *)offset {
    if (offset != nil) {
        [parameters setObject:offset forKey:SDLNameOffset];
    } else {
        [parameters removeObjectForKey:SDLNameOffset];
    }
}

- (nullable NSNumber<SDLUInt> *)offset {
    return [parameters objectForKey:SDLNameOffset];
}

- (void)setLength:(nullable NSNumber<SDLUInt> *)length {
    if (length != nil) {
        [parameters setObject:length forKey:SDLNameLength];
    } else {
        [parameters removeObjectForKey:SDLNameLength];
    }
}

- (nullable NSNumber<SDLUInt> *)length {
    return [parameters objectForKey:SDLNameLength];
}

@end

NS_ASSUME_NONNULL_END
