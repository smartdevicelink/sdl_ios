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
    [self setObject:syncFileName forName:SDLNameSyncFileName];
}

- (NSString *)syncFileName {
    return [parameters objectForKey:SDLNameSyncFileName];
}

- (void)setFileType:(SDLFileType)fileType {
    [self setObject:fileType forName:SDLNameFileType];
}

- (SDLFileType)fileType {
    NSObject *obj = [parameters objectForKey:SDLNameFileType];
    return (SDLFileType)obj;
}

- (void)setPersistentFile:(NSNumber<SDLBool> *)persistentFile {
    [self setObject:persistentFile forName:SDLNamePersistentFile];
}

- (NSNumber<SDLBool> *)persistentFile {
    return [parameters objectForKey:SDLNamePersistentFile];
}

- (void)setSystemFile:(NSNumber<SDLBool> *)systemFile {
    [self setObject:systemFile forName:SDLNameSystemFile];
}

- (NSNumber<SDLBool> *)systemFile {
    return [parameters objectForKey:SDLNameSystemFile];
}

- (void)setOffset:(NSNumber<SDLUInt> *)offset {
    [self setObject:offset forName:SDLNameOffset];
}

- (NSNumber<SDLUInt> *)offset {
    return [parameters objectForKey:SDLNameOffset];
}

- (void)setLength:(NSNumber<SDLUInt> *)length {
    [self setObject:length forName:SDLNameLength];
}

- (NSNumber<SDLUInt> *)length {
    return [parameters objectForKey:SDLNameLength];
}

@end
