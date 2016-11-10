//  SDLOnHashChange.m
//


#import "SDLOnHashChange.h"

#import "SDLNames.h"

@implementation SDLOnHashChange

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnHashChange]) {
    }
    return self;
}

- (void)setHashID:(NSString *)hashID {
    [parameters sdl_setObject:hashID forName:SDLNameHashId];
}

- (NSString *)hashID {
    return [parameters sdl_objectForName:SDLNameHashId];
}

@end
