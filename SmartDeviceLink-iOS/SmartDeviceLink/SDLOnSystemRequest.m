//  SDLOnSystemRequest.m
//

#import "SDLOnSystemRequest.h"

#import "SDLFileType.h"
#import "SDLNames.h"
#import "SDLRequestType.h"


@implementation SDLOnSystemRequest

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnSystemRequest]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setRequestType:(SDLRequestType *)requestType {
    if (requestType != nil) {
        [parameters setObject:requestType forKey:NAMES_requestType];
    } else {
        [parameters removeObjectForKey:NAMES_requestType];
    }
}

- (SDLRequestType *)requestType {
    NSObject *obj = [parameters objectForKey:NAMES_requestType];
    if (obj == nil || [obj isKindOfClass:SDLRequestType.class]) {
        return (SDLRequestType *)obj;
    } else {
        return [SDLRequestType valueOf:(NSString *)obj];
    }
}

- (void)setUrl:(NSString *)url {
    if (url != nil) {
        [parameters setObject:url forKey:NAMES_url];
    } else {
        [parameters removeObjectForKey:NAMES_url];
    }
}

- (NSString *)url {
    return [parameters objectForKey:NAMES_url];
}

- (void)setTimeout:(NSNumber *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:NAMES_timeout];
    } else {
        [parameters removeObjectForKey:NAMES_timeout];
    }
}

- (NSNumber *)timeout {
    return [parameters objectForKey:NAMES_timeout];
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
