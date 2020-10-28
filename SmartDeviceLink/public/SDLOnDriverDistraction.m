//  SDLOnDriverDistraction.m
//

#import "SDLOnDriverDistraction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLDriverDistractionState.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnDriverDistraction

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnDriverDistraction]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithState:(SDLDriverDistractionState)state {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.state = state;
    return self;
}

- (instancetype)initWithState:(SDLDriverDistractionState)state lockScreenDismissalEnabled:(nullable NSNumber<SDLBool> *)lockScreenDismissalEnabled lockScreenDismissalWarning:(nullable NSString *)lockScreenDismissalWarning {
    self = [self initWithState:state];
    if (!self) {
        return nil;
    }
    self.lockScreenDismissalEnabled = lockScreenDismissalEnabled;
    self.lockScreenDismissalWarning = lockScreenDismissalWarning;
    return self;
}

- (void)setState:(SDLDriverDistractionState)state {
    [self.parameters sdl_setObject:state forName:SDLRPCParameterNameState];
}

- (SDLDriverDistractionState)state {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameState error:&error];
}

- (void)setLockScreenDismissalEnabled:(nullable NSNumber<SDLBool> *)lockScreenDismissalEnabled {
    [self.parameters sdl_setObject:lockScreenDismissalEnabled forName:SDLRPCParameterNameLockScreenDismissalEnabled];
}

- (nullable NSNumber<SDLBool> *)lockScreenDismissalEnabled {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameLockScreenDismissalEnabled ofClass:NSNumber.class error:&error];
}

- (void)setLockScreenDismissalWarning:(nullable NSString *)lockScreenDismissalWarning {
    [self.parameters sdl_setObject:lockScreenDismissalWarning forName:SDLRPCParameterNameLockScreenDismissalWarning];
}

- (nullable NSString *)lockScreenDismissalWarning {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameLockScreenDismissalWarning ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
