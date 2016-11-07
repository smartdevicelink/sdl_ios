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

- (instancetype)initWithFileName:(NSString *)fileName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.syncFileName = fileName;

    return self;
}

- (void)setSyncFileName:(NSString *)syncFileName {
    [self setObject:syncFileName forName:SDLNameSyncFileName];
}

- (NSString *)syncFileName {
    return [parameters objectForKey:SDLNameSyncFileName];
}

@end
