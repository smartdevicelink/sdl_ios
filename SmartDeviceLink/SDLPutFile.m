//  SDLPutFile.m
//

#import "SDLPutFile.h"

#import "SDLFileType.h"
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

- (void)setFileType:(SDLFileType *)fileType {
    if (fileType != nil) {
        [parameters setObject:fileType forKey:SDLNameFileType];
    } else {
        [parameters removeObjectForKey:SDLNameFileType];
    }
}

- (SDLFileType *)fileType {
    NSObject *obj = [parameters objectForKey:SDLNameFileType];
    if (obj == nil || [obj isKindOfClass:SDLFileType.class]) {
        return (SDLFileType *)obj;
    } else {
        return [SDLFileType valueOf:(NSString *)obj];
    }
}

- (void)setPersistentFile:(NSNumber *)persistentFile {
    if (persistentFile != nil) {
        [parameters setObject:persistentFile forKey:SDLNamePersistentFile];
    } else {
        [parameters removeObjectForKey:SDLNamePersistentFile];
    }
}

- (NSNumber *)persistentFile {
    return [parameters objectForKey:SDLNamePersistentFile];
}

- (void)setSystemFile:(NSNumber *)systemFile {
    if (systemFile != nil) {
        [parameters setObject:systemFile forKey:SDLNameSystemFile];
    } else {
        [parameters removeObjectForKey:SDLNameSystemFile];
    }
}

- (NSNumber *)systemFile {
    return [parameters objectForKey:SDLNameSystemFile];
}

- (void)setOffset:(NSNumber *)offset {
    if (offset != nil) {
        [parameters setObject:offset forKey:SDLNameOffset];
    } else {
        [parameters removeObjectForKey:SDLNameOffset];
    }
}

- (NSNumber *)offset {
    return [parameters objectForKey:SDLNameOffset];
}

- (void)setLength:(NSNumber *)length {
    if (length != nil) {
        [parameters setObject:length forKey:SDLNameLength];
    } else {
        [parameters removeObjectForKey:SDLNameLength];
    }
}

- (NSNumber *)length {
    return [parameters objectForKey:SDLNameLength];
}

@end
