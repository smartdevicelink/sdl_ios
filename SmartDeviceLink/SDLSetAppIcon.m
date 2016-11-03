//  SDLSetAppIcon.m
//


#import "SDLSetAppIcon.h"

#import "SDLNames.h"

@implementation SDLSetAppIcon

- (instancetype)init {
    if (self = [super initWithName:NAMES_SetAppIcon]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
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
    if (syncFileName != nil) {
        [parameters setObject:syncFileName forKey:NAMES_syncFileName];
    } else {
        [parameters removeObjectForKey:NAMES_syncFileName];
    }
}

- (NSString *)syncFileName {
    return [parameters objectForKey:NAMES_syncFileName];
}

@end
