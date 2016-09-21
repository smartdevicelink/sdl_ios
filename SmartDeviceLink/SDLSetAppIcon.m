//  SDLSetAppIcon.m
//


#import "SDLSetAppIcon.h"



@implementation SDLSetAppIcon

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetAppIcon]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setSyncFileName:(NSString *)syncFileName {
    if (syncFileName != nil) {
        [parameters setObject:syncFileName forKey:SDLNameSyncFileName];
    } else {
        [parameters removeObjectForKey:SDLNameSyncFileName];
    }
}

- (NSString *)syncFileName {
    return [parameters objectForKey:SDLNameSyncFileName];
}

@end
