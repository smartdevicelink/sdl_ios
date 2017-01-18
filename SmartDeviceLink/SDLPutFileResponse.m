//  SDLPutFileResponse.m
//


#import "SDLPutFileResponse.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPutFileResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNamePutFile]) {
    }
    return self;
}

- (void)setSpaceAvailable:(NSNumber<SDLInt> *)spaceAvailable {
    if (spaceAvailable != nil) {
        [parameters setObject:spaceAvailable forKey:SDLNameSpaceAvailable];
    } else {
        [parameters removeObjectForKey:SDLNameSpaceAvailable];
    }
}

- (NSNumber<SDLInt> *)spaceAvailable {
    return [parameters objectForKey:SDLNameSpaceAvailable];
}

@end

NS_ASSUME_NONNULL_END
