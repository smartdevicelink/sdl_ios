//  SDLOnCommand.m
//

#import "SDLOnCommand.h"

#import "SDLNames.h"
#import "SDLTriggerSource.h"


@implementation SDLOnCommand

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnCommand]) {
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
        [parameters setObject:cmdID forKey:NAMES_cmdID];
    } else {
        [parameters removeObjectForKey:NAMES_cmdID];
    }
}

- (NSNumber *)cmdID {
    return [parameters objectForKey:NAMES_cmdID];
}

- (void)setTriggerSource:(SDLTriggerSource *)triggerSource {
    if (triggerSource != nil) {
        [parameters setObject:triggerSource forKey:NAMES_triggerSource];
    } else {
        [parameters removeObjectForKey:NAMES_triggerSource];
    }
}

- (SDLTriggerSource *)triggerSource {
    NSObject *obj = [parameters objectForKey:NAMES_triggerSource];
    if (obj == nil || [obj isKindOfClass:SDLTriggerSource.class]) {
        return (SDLTriggerSource *)obj;
    } else {
        return [SDLTriggerSource valueOf:(NSString *)obj];
    }
}

@end
