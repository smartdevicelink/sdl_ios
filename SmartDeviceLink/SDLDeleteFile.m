//  SDLDeleteFile.m
//


#import "SDLDeleteFile.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteFile

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDeleteFile]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithFileName:(NSString *)fileName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.syncFileName = fileName;

    return self;
}

- (void)setSyncFileName:(NSString *)syncFileName {
    [self.parameters sdl_setObject:syncFileName forName:SDLRPCParameterNameSyncFileName];
}

- (NSString *)syncFileName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSyncFileName ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
