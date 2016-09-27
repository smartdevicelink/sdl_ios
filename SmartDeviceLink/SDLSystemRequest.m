//  SDLSystemRequest.m
//


#import "SDLSystemRequest.h"

#import "SDLNames.h"
#import "SDLRequestType.h"

@implementation SDLSystemRequest

- (instancetype)init {
    if (self = [super initWithName:SDLNameSystemRequest]) {
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

- (void)setFileName:(NSString *)fileName {
    if (fileName != nil) {
        [parameters setObject:fileName forKey:SDLNameFilename];
    } else {
        [parameters removeObjectForKey:SDLNameFilename];
    }
}

- (NSString *)fileName {
    return [parameters objectForKey:SDLNameFilename];
}

@end
