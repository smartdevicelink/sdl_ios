//  SDLDeleteCommand.m
//


#import "SDLDeleteCommand.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteCommand

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteCommand]) {
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
    if (cmdID != nil) {
        [parameters setObject:cmdID forKey:SDLNameCommandId];
    } else {
        [parameters removeObjectForKey:SDLNameCommandId];
    }
}

- (NSNumber<SDLInt> *)cmdID {
    return [parameters objectForKey:SDLNameCommandId];
}

@end

NS_ASSUME_NONNULL_END
