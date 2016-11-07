//  SDLPutFileResponse.m
//


#import "SDLPutFileResponse.h"

#import "SDLNames.h"

@implementation SDLPutFileResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNamePutFile]) {
    }
    return self;
}

- (void)setSpaceAvailable:(NSNumber<SDLInt> *)spaceAvailable {
    [self setObject:spaceAvailable forName:SDLNameSpaceAvailable];
}

- (NSNumber<SDLInt> *)spaceAvailable {
    return [parameters objectForKey:SDLNameSpaceAvailable];
}

@end
