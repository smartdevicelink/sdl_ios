//  SDLPutFileResponse.m
//


#import "SDLPutFileResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPutFileResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNamePutFile]) {
    }
    return self;
}

- (void)setSpaceAvailable:(nullable NSNumber<SDLInt> *)spaceAvailable {
    [parameters sdl_setObject:spaceAvailable forName:SDLNameSpaceAvailable];
}

- (nullable NSNumber<SDLInt> *)spaceAvailable {
    return [parameters sdl_objectForName:SDLNameSpaceAvailable];
}

@end

NS_ASSUME_NONNULL_END
