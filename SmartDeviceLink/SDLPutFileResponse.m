//  SDLPutFileResponse.m
//


#import "SDLPutFileResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPutFileResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNamePutFile]) {
    }
    return self;
}

- (void)setSpaceAvailable:(NSNumber<SDLInt> *)spaceAvailable {
    [parameters sdl_setObject:spaceAvailable forName:SDLNameSpaceAvailable];
}

- (NSNumber<SDLInt> *)spaceAvailable {
    return [parameters sdl_objectForName:SDLNameSpaceAvailable];
}

- (void)setResultCode:(nullable SDLResult)resultCode {
    [parameters sdl_setObject:resultCode forName:SDLNameResultCode];
}

- (nullable SDLResult)resultCode {
    return [parameters sdl_objectForName:SDLNameResultCode];
}

@end

NS_ASSUME_NONNULL_END
