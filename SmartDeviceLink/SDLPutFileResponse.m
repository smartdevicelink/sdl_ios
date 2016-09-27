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

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
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
