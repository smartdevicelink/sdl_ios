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
    [self setObject:requestType forName:SDLNameRequestType];
}

- (SDLRequestType)requestType {
    NSObject *obj = [parameters objectForKey:SDLNameRequestType];
    return (SDLRequestType)obj;
}

- (void)setFileName:(NSString *)fileName {
    [self setObject:fileName forName:SDLNameFilename];
}

- (NSString *)fileName {
    return [parameters objectForKey:SDLNameFilename];
}

@end
