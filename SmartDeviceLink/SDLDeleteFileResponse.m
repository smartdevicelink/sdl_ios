//  SDLDeleteFileResponse.m
//


#import "SDLDeleteFileResponse.h"

#import "SDLNames.h"

@implementation SDLDeleteFileResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteFile]) {
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
