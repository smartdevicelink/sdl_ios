//  SDLOnCommand.m
//

#import "SDLOnCommand.h"

#import "SDLNames.h"

@implementation SDLOnCommand

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnCommand]) {
    }
    return self;
}

- (void)setCmdID:(NSNumber<SDLInt> *)cmdID {
    [self setObject:cmdID forName:SDLNameCommandId];
}

- (NSNumber<SDLInt> *)cmdID {
    return [parameters objectForKey:SDLNameCommandId];
}

- (void)setTriggerSource:(SDLTriggerSource)triggerSource {
    [self setObject:triggerSource forName:SDLNameTriggerSource];
}

- (SDLTriggerSource)triggerSource {
    NSObject *obj = [parameters objectForKey:SDLNameTriggerSource];
    return (SDLTriggerSource)obj;
}

@end
