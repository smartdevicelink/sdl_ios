//  SDLOnCommand.m
//

#import "SDLOnCommand.h"


#import "SDLTriggerSource.h"


@implementation SDLOnCommand

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnCommand]) {
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

- (void)setTriggerSource:(SDLTriggerSource *)triggerSource {
    if (triggerSource != nil) {
        [parameters setObject:triggerSource forKey:SDLNameTriggerSource];
    } else {
        [parameters removeObjectForKey:SDLNameTriggerSource];
    }
}

- (SDLTriggerSource *)triggerSource {
    NSObject *obj = [parameters objectForKey:SDLNameTriggerSource];
    if (obj == nil || [obj isKindOfClass:SDLTriggerSource.class]) {
        return (SDLTriggerSource *)obj;
    } else {
        return [SDLTriggerSource valueOf:(NSString *)obj];
    }
}

@end
