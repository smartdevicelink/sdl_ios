//  SDLSystemRequest.m
//


#import "SDLSystemRequest.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSystemRequest

- (instancetype)init {
    if (self = [super initWithName:SDLNameSystemRequest]) {
    }
    return self;
}

- (instancetype)initWithType:(SDLRequestType)requestType fileName:(nullable NSString *)fileName {
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

- (void)setFileName:(nullable NSString *)fileName {
    if (fileName != nil) {
        [parameters setObject:fileName forKey:SDLNameFilename];
    } else {
        [parameters removeObjectForKey:SDLNameFilename];
    }
}

- (nullable NSString *)fileName {
    return [parameters objectForKey:SDLNameFilename];
}

@end

NS_ASSUME_NONNULL_END
