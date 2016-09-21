//  SDLDeleteCommand.m
//


#import "SDLDeleteCommand.h"



@implementation SDLDeleteCommand

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteCommand]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setCmdID:(NSNumber *)cmdID {
    if (cmdID != nil) {
        [parameters setObject:cmdID forKey:SDLNameCommandId];
    } else {
        [parameters removeObjectForKey:SDLNameCommandId];
    }
}

- (NSNumber *)cmdID {
    return [parameters objectForKey:SDLNameCommandId];
}

@end
