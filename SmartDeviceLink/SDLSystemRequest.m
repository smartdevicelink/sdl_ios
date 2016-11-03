//  SDLSystemRequest.m
//


#import "SDLSystemRequest.h"

#import "SDLNames.h"

@implementation SDLSystemRequest

- (instancetype)init {
    if (self = [super initWithName:SDLNameSystemRequest]) {
    }
    return self;
}

- (instancetype)initWithType:(SDLRequestType)requestType fileName:(NSString *)fileName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.requestType = requestType;
    self.fileName = fileName;

    return self;
}

- (void)setRequestType:(SDLRequestType)requestType {
    if (requestType != nil) {
        [parameters setObject:requestType forKey:SDLNameRequestType];
    } else {
        [parameters removeObjectForKey:SDLNameRequestType];
    }
}

- (SDLRequestType)requestType {
    NSObject *obj = [parameters objectForKey:SDLNameRequestType];
    return (SDLRequestType)obj;
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
