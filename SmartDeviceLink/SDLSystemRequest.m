//  SDLSystemRequest.m
//


#import "SDLSystemRequest.h"

#import "NSMutableDictionary+Store.h"
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
    [parameters sdl_setObject:requestType forName:SDLNameRequestType];
}

- (SDLRequestType)requestType {
    NSObject *obj = [parameters sdl_objectForName:SDLNameRequestType];
    return (SDLRequestType)obj;
}

- (void)setFileName:(NSString *)fileName {
    [parameters sdl_setObject:fileName forName:SDLNameFilename];
}

- (NSString *)fileName {
    return [parameters sdl_objectForName:SDLNameFilename];
}

@end
