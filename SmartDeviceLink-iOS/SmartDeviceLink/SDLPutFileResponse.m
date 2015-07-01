//  SDLPutFileResponse.m
//


#import "SDLPutFileResponse.h"

#import "SDLNames.h"

@implementation SDLPutFileResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_PutFile]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setSpaceAvailable:(NSNumber *)spaceAvailable {
    if (spaceAvailable != nil) {
        [parameters setObject:spaceAvailable forKey:NAMES_spaceAvailable];
    } else {
        [parameters removeObjectForKey:NAMES_spaceAvailable];
    }
}

- (NSNumber *)spaceAvailable {
    return [parameters objectForKey:NAMES_spaceAvailable];
}

@end
