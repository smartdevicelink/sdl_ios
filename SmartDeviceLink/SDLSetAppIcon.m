//  SDLSetAppIcon.m
//


#import "SDLSetAppIcon.h"

#import "SDLNames.h"

@implementation SDLSetAppIcon

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetAppIcon]) {
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
