//  SDLOnCommand.m
//

#import "SDLOnCommand.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnCommand

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnCommand]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setCmdID:(NSNumber<SDLInt> *)cmdID {
    [self.parameters sdl_setObject:cmdID forName:SDLRPCParameterNameCommandId];
}

- (NSNumber<SDLInt> *)cmdID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCommandId ofClass:NSNumber.class error:&error];
}

- (void)setTriggerSource:(SDLTriggerSource)triggerSource {
    [self.parameters sdl_setObject:triggerSource forName:SDLRPCParameterNameTriggerSource];
}

- (SDLTriggerSource)triggerSource {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameTriggerSource error:&error];
}

@end

NS_ASSUME_NONNULL_END
