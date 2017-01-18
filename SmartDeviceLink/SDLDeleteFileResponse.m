//  SDLDeleteFileResponse.m
//


#import "SDLDeleteFileResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteFileResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteFile]) {
    }
    return self;
}

- (void)setSpaceAvailable:(NSNumber<SDLInt> *)spaceAvailable {
    [parameters sdl_setObject:spaceAvailable forName:SDLNameSpaceAvailable];
}

- (NSNumber<SDLInt> *)spaceAvailable {
    return [parameters objectForKey:SDLNameSpaceAvailable];
}

@end

NS_ASSUME_NONNULL_END
