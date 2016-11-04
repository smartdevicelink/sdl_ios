//  SDLPutFile.m
//

#import "SDLPutFile.h"

#import "SDLFileType.h"
#import "SDLNames.h"


@implementation SDLPutFile

- (instancetype)init {
    if (self = [super initWithName:NAMES_PutFile]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType *)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt64)offset length:(UInt64)length {
    self = [self initWithFileName:fileName fileType:fileType persistentFile:persistentFile];
    if (!self) {
        return nil;
    }

    self.systemFile = @(systemFile);
    self.offset = @(offset);
    self.length = @(length);

    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType *)fileType persistentFile:(BOOL)persistentFile {
    self = [self initWithFileName:fileName fileType:fileType];
    if (!self) {
        return nil;
    }

    self.persistentFile = @(persistentFile);

    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType *)fileType {
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
        [parameters setObject:syncFileName forKey:NAMES_syncFileName];
    } else {
        [parameters removeObjectForKey:NAMES_syncFileName];
    }
}

- (NSString *)syncFileName {
    return [parameters objectForKey:NAMES_syncFileName];
}

- (void)setFileType:(SDLFileType *)fileType {
    if (fileType != nil) {
        [parameters setObject:fileType forKey:NAMES_fileType];
    } else {
        [parameters removeObjectForKey:NAMES_fileType];
    }
}

- (SDLFileType *)fileType {
    NSObject *obj = [parameters objectForKey:NAMES_fileType];
    if (obj == nil || [obj isKindOfClass:SDLFileType.class]) {
        return (SDLFileType *)obj;
    } else {
        return [SDLFileType valueOf:(NSString *)obj];
    }
}

- (void)setPersistentFile:(NSNumber *)persistentFile {
    if (persistentFile != nil) {
        [parameters setObject:persistentFile forKey:NAMES_persistentFile];
    } else {
        [parameters removeObjectForKey:NAMES_persistentFile];
    }
}

- (NSNumber *)persistentFile {
    return [parameters objectForKey:NAMES_persistentFile];
}

- (void)setSystemFile:(NSNumber *)systemFile {
    if (systemFile != nil) {
        [parameters setObject:systemFile forKey:NAMES_systemFile];
    } else {
        [parameters removeObjectForKey:NAMES_systemFile];
    }
}

- (NSNumber *)systemFile {
    return [parameters objectForKey:NAMES_systemFile];
}

- (void)setOffset:(NSNumber *)offset {
    if (offset != nil) {
        [parameters setObject:offset forKey:NAMES_offset];
    } else {
        [parameters removeObjectForKey:NAMES_offset];
    }
}

- (NSNumber *)offset {
    return [parameters objectForKey:NAMES_offset];
}

- (void)setLength:(NSNumber *)length {
    if (length != nil) {
        [parameters setObject:length forKey:NAMES_length];
    } else {
        [parameters removeObjectForKey:NAMES_length];
    }
}

- (NSNumber *)length {
    return [parameters objectForKey:NAMES_length];
}

@end
