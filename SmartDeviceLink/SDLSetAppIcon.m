//  SDLSetAppIcon.m
//


#import "SDLSetAppIcon.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

@implementation SDLSetAppIcon

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSetAppIcon]) {
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
    [parameters sdl_setObject:syncFileName forName:SDLRPCParameterNameSyncFileName];
}

- (NSString *)syncFileName {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameSyncFileName ofClass:NSString.class error:&error];
}

@end
