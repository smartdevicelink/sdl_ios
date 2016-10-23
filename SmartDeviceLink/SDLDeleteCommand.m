//  SDLDeleteCommand.m
//


#import "SDLDeleteCommand.h"

#import "SDLNames.h"

@implementation SDLDeleteCommand

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteCommand]) {
    }
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
