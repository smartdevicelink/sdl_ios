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
    if (hashID != nil) {
        [parameters setObject:hashID forKey:SDLNameHashId];
    } else {
        [parameters removeObjectForKey:SDLNameHashId];
    }
}

- (NSString *)hashID {
    return [parameters objectForKey:SDLNameHashId];
}

@end
