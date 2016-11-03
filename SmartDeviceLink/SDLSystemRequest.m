//  SDLSystemRequest.m
//


#import "SDLSystemRequest.h"

#import "SDLNames.h"
#import "SDLRequestType.h"


@implementation SDLSystemRequest

- (instancetype)init {
    if (self = [super initWithName:NAMES_SystemRequest]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithType:(SDLRequestType *)requestType fileName:(NSString *)fileName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.requestType = requestType;
    self.fileName = fileName;

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

- (void)setFileName:(NSString *)fileName {
    if (fileName != nil) {
        [parameters setObject:fileName forKey:NAMES_fileName];
    } else {
        [parameters removeObjectForKey:NAMES_fileName];
    }
}

- (NSString *)fileName {
    return [parameters objectForKey:NAMES_fileName];
}

@end
