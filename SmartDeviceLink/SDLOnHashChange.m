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
    [self setObject:hashID forName:SDLNameHashId];
}

- (NSString *)hashID {
    return [parameters objectForKey:SDLNameHashId];
}

@end
