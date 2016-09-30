//  SDLOnSystemRequest.m
//

#import "SDLOnSystemRequest.h"

#import "SDLFileType.h"
#import "SDLNames.h"
#import "SDLRequestType.h"

@implementation SDLOnSystemRequest

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnSystemRequest]) {
    }
    return self;
}

- (void)setRequestType:(SDLRequestType *)requestType {
    if (requestType != nil) {
        [parameters setObject:requestType forKey:SDLNameRequestType];
    } else {
        [parameters removeObjectForKey:SDLNameRequestType];
    }
}

- (SDLRequestType *)requestType {
    NSObject *obj = [parameters objectForKey:SDLNameRequestType];
    if (obj == nil || [obj isKindOfClass:SDLRequestType.class]) {
        return (SDLRequestType *)obj;
    } else {
        return [SDLRequestType valueOf:(NSString *)obj];
    }
}

- (void)setUrl:(NSString *)url {
    if (url != nil) {
        [parameters setObject:url forKey:SDLNameURL];
    } else {
        [parameters removeObjectForKey:SDLNameURL];
    }
}

- (NSString *)url {
    return [parameters objectForKey:SDLNameURL];
}

- (void)setTimeout:(NSNumber *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:SDLNameTimeout];
    } else {
        [parameters removeObjectForKey:SDLNameTimeout];
    }
}

- (NSNumber *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
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
