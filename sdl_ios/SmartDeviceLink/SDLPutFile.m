//  SDLPutFile.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLPutFile.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLPutFile

-(id) init {
    if (self = [super initWithName:NAMES_PutFile]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setSyncFileName:(NSString *)syncFileName {
    [parameters setOrRemoveObject:syncFileName forKey:NAMES_syncFileName];
}

-(NSString*) syncFileName {
    return [parameters objectForKey:NAMES_syncFileName];
}

- (void)setFileType:(SDLFileType *)fileType {
    [parameters setOrRemoveObject:fileType forKey:NAMES_fileType];
}

-(SDLFileType*) fileType {
    NSObject* obj = [parameters objectForKey:NAMES_fileType];
    if ([obj isKindOfClass:SDLFileType.class]) {
        return (SDLFileType*)obj;
    } else {
        return [SDLFileType valueOf:(NSString*)obj];
    }
}

- (void)setPersistentFile:(NSNumber *)persistentFile {
    [parameters setOrRemoveObject:persistentFile forKey:NAMES_persistentFile];
}

-(NSNumber*) persistentFile {
    return [parameters objectForKey:NAMES_persistentFile];
}

- (void)setSystemFile:(NSNumber *)systemFile {
    [parameters setOrRemoveObject:systemFile forKey:NAMES_systemFile];
}

-(NSNumber*) systemFile {
    return [parameters objectForKey:NAMES_systemFile];
}

- (void)setOffset:(NSNumber *)offset {
    [parameters setOrRemoveObject:offset forKey:NAMES_offset];
}

-(NSNumber*) offset {
    return [parameters objectForKey:NAMES_offset];
}

- (void)setLength:(NSNumber *)length {
    [parameters setOrRemoveObject:length forKey:NAMES_length];
}

-(NSNumber*) length {
    return [parameters objectForKey:NAMES_length];
}

@end
