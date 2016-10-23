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

- (void)setPersistentFile:(NSNumber<SDLBool> *)persistentFile {
    if (persistentFile != nil) {
        [parameters setObject:persistentFile forKey:SDLNamePersistentFile];
    } else {
        [parameters removeObjectForKey:SDLNamePersistentFile];
    }
}

- (NSNumber<SDLBool> *)persistentFile {
    return [parameters objectForKey:SDLNamePersistentFile];
}

- (void)setSystemFile:(NSNumber<SDLBool> *)systemFile {
    if (systemFile != nil) {
        [parameters setObject:systemFile forKey:SDLNameSystemFile];
    } else {
        [parameters removeObjectForKey:SDLNameSystemFile];
    }
}

- (NSNumber<SDLBool> *)systemFile {
    return [parameters objectForKey:SDLNameSystemFile];
}

- (void)setOffset:(NSNumber<SDLUInt> *)offset {
    if (offset != nil) {
        [parameters setObject:offset forKey:SDLNameOffset];
    } else {
        [parameters removeObjectForKey:SDLNameOffset];
    }
}

- (NSNumber<SDLUInt> *)offset {
    return [parameters objectForKey:SDLNameOffset];
}

- (void)setLength:(NSNumber<SDLUInt> *)length {
    if (length != nil) {
        [parameters setObject:length forKey:SDLNameLength];
    } else {
        [parameters removeObjectForKey:SDLNameLength];
    }
}

- (NSNumber<SDLUInt> *)length {
    return [parameters objectForKey:SDLNameLength];
}

@end
