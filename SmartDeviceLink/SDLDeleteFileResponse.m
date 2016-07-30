//  SDLDeleteFileResponse.m
//


#import "SDLDeleteFileResponse.h"

#import "SDLNames.h"

@implementation SDLDeleteFileResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_DeleteFile]) {
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
