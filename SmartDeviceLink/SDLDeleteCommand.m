//  SDLDeleteCommand.m
//


#import "SDLDeleteCommand.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteCommand

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDeleteCommand]) {
    }
    return self;
}

- (instancetype)initWithId:(UInt32)commandId {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.cmdID = @(commandId);

    return self;
}

- (void)setCmdID:(NSNumber<SDLInt> *)cmdID {
    [parameters sdl_setObject:cmdID forName:SDLRPCParameterNameCommandId];
}

- (NSNumber<SDLInt> *)cmdID {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameCommandId ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
