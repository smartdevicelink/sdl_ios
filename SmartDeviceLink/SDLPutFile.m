//  SDLPutFile.m
//

#import "SDLPutFile.h"

#import "SDLNames.h"

@implementation SDLPutFile

- (instancetype)init {
    if (self = [super initWithName:SDLNamePutFile]) {
    }
    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt64)offset length:(UInt64)length {
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
    [parameters sdl_setObject:syncFileName forName:SDLNameSyncFileName];
}

- (NSString *)syncFileName {
    return [parameters sdl_objectForName:SDLNameSyncFileName];
}

- (void)setFileType:(SDLFileType)fileType {
    [parameters sdl_setObject:fileType forName:SDLNameFileType];
}

- (SDLFileType)fileType {
    NSObject *obj = [parameters sdl_objectForName:SDLNameFileType];
    return (SDLFileType)obj;
}

- (void)setPersistentFile:(NSNumber<SDLBool> *)persistentFile {
    [parameters sdl_setObject:persistentFile forName:SDLNamePersistentFile];
}

- (NSNumber<SDLBool> *)persistentFile {
    return [parameters sdl_objectForName:SDLNamePersistentFile];
}

- (void)setSystemFile:(NSNumber<SDLBool> *)systemFile {
    [parameters sdl_setObject:systemFile forName:SDLNameSystemFile];
}

- (NSNumber<SDLBool> *)systemFile {
    return [parameters sdl_objectForName:SDLNameSystemFile];
}

- (void)setOffset:(NSNumber<SDLUInt> *)offset {
    [parameters sdl_setObject:offset forName:SDLNameOffset];
}

- (NSNumber<SDLUInt> *)offset {
    return [parameters sdl_objectForName:SDLNameOffset];
}

- (void)setLength:(NSNumber<SDLUInt> *)length {
    [parameters sdl_setObject:length forName:SDLNameLength];
}

- (NSNumber<SDLUInt> *)length {
    return [parameters sdl_objectForName:SDLNameLength];
}

@end
