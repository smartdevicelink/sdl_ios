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

- (void)setSpaceAvailable:(NSNumber *)spaceAvailable {
    if (spaceAvailable != nil) {
        [parameters setObject:spaceAvailable forKey:SDLNameSpaceAvailable];
    } else {
        [parameters removeObjectForKey:SDLNameSpaceAvailable];
    }
}

- (NSNumber *)spaceAvailable {
    return [parameters objectForKey:SDLNameSpaceAvailable];
}

@end
