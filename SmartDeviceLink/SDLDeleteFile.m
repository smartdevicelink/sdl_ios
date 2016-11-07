//  SDLDeleteFile.m
//


#import "SDLDeleteFile.h"

#import "SDLNames.h"

@implementation SDLDeleteFile

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteFile]) {
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
