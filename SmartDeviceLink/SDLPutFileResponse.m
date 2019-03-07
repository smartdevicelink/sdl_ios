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

- (void)setSpaceAvailable:(nullable NSNumber<SDLInt> *)spaceAvailable {
    [parameters sdl_setObject:spaceAvailable forName:SDLNameSpaceAvailable];
}

- (nullable NSNumber<SDLInt> *)spaceAvailable {
    return [parameters sdl_objectForName:SDLNameSpaceAvailable ofClass:NSNumber.class];
}

@end

NS_ASSUME_NONNULL_END
