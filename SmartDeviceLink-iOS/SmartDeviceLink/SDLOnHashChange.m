//  SDLOnHashChange.m
//


#import "SDLOnHashChange.h"

#import "SDLNames.h"

@implementation SDLOnHashChange

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnHashChange]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setHashID:(NSString *)hashID {
    if (hashID != nil) {
        [parameters setObject:hashID forKey:NAMES_hashID];
    } else {
        [parameters removeObjectForKey:NAMES_hashID];
    }
}

- (NSString *)hashID {
    return [parameters objectForKey:NAMES_hashID];
}

@end
