//  SDLOnHashChange.m
//


#import "SDLOnHashChange.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
