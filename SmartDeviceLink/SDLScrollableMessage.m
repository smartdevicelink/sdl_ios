//  SDLScrollableMessage.m
//


#import "SDLScrollableMessage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSoftButton.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLScrollableMessage

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameScrollableMessage]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithMessage:(NSString *)message timeout:(UInt16)timeout softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    self = [self initWithMessage:message];
    if (!self) {
        return nil;
    }

    self.timeout = @(timeout);
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (instancetype)initWithMessage:(NSString *)message {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.scrollableMessageBody = message;

    return self;
}

- (void)setScrollableMessageBody:(NSString *)scrollableMessageBody {
    [self.parameters sdl_setObject:scrollableMessageBody forName:SDLRPCParameterNameScrollableMessageBody];
}

- (NSString *)scrollableMessageBody {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameScrollableMessageBody ofClass:NSString.class error:&error];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    [self.parameters sdl_setObject:timeout forName:SDLRPCParameterNameTimeout];
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTimeout ofClass:NSNumber.class error:nil];
}

- (void)setSoftButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    [self.parameters sdl_setObject:softButtons forName:SDLRPCParameterNameSoftButtons];
}

- (nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameSoftButtons ofClass:SDLSoftButton.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
