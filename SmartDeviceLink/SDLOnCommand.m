//  SDLOnCommand.m
//

#import "SDLOnCommand.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnCommand

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnCommand]) {
    }
    return self;
}

- (void)setCmdID:(NSNumber<SDLInt> *)cmdID {
    [parameters sdl_setObject:cmdID forName:SDLRPCParameterNameCommandId];
}

- (NSNumber<SDLInt> *)cmdID {
    return [parameters sdl_objectForName:SDLRPCParameterNameCommandId];
}

- (void)setTriggerSource:(SDLTriggerSource)triggerSource {
    [parameters sdl_setObject:triggerSource forName:SDLRPCParameterNameTriggerSource];
}

- (SDLTriggerSource)triggerSource {
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameTriggerSource];
    return (SDLTriggerSource)obj;
}

@end

NS_ASSUME_NONNULL_END
