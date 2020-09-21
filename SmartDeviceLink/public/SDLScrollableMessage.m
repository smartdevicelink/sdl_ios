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

- (instancetype)initWithScrollableMessageBody:(NSString *)message timeout:(nullable NSNumber *)timeout softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons cancelID:(nullable NSNumber *)cancelID {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.scrollableMessageBody = message;
    self.timeout = timeout;
    self.softButtons = softButtons;
    self.cancelID = cancelID;

    return self;
}

- (instancetype)initWithMessage:(NSString *)message timeout:(UInt16)timeout softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons cancelID:(UInt32)cancelID {
    return [self initWithScrollableMessageBody:message timeout:@(timeout) softButtons:softButtons cancelID:@(cancelID)];
}

- (instancetype)initWithMessage:(NSString *)message {
    return [self initWithScrollableMessageBody:message timeout:nil softButtons:nil cancelID:nil];
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

- (void)setCancelID:(nullable NSNumber<SDLInt> *)cancelID {
    [self.parameters sdl_setObject:cancelID forName:SDLRPCParameterNameCancelID];
}

- (nullable NSNumber<SDLInt> *)cancelID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCancelID ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
