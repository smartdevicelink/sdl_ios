//  SDLDeleteFile.m
//


#import "SDLDeleteFile.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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
    [parameters sdl_setObject:syncFileName forName:SDLNameSyncFileName];
}

- (NSString *)syncFileName {
    return [parameters sdl_objectForName:SDLNameSyncFileName];
}

@end

NS_ASSUME_NONNULL_END
