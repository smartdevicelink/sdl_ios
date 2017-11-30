//  SDLSystemRequest.m
//


#import "SDLSystemRequest.h"

#import "NSMutableDictionary+Store.h"
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
    [parameters sdl_setObject:requestType forName:SDLNameRequestType];
}

- (SDLRequestType)requestType {
    return [parameters sdl_objectForName:SDLNameRequestType];
}

- (void)setFileName:(nullable NSString *)fileName {
    [parameters sdl_setObject:fileName forName:SDLNameFilename];
}

- (nullable NSString *)fileName {
    return [parameters sdl_objectForName:SDLNameFilename];
}

@end

NS_ASSUME_NONNULL_END
