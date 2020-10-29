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

- (instancetype)initWithScrollableMessageBody:(NSString *)scrollableMessageBody {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.scrollableMessageBody = scrollableMessageBody;
    return self;
}

- (instancetype)initWithScrollableMessageBody:(NSString *)scrollableMessageBody timeout:(nullable NSNumber<SDLUInt> *)timeout softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons cancelID:(nullable NSNumber<SDLInt> *)cancelID {
    self = [self initWithScrollableMessageBody:scrollableMessageBody];
    if (!self) {
        return nil;
    }
    self.timeout = timeout;
    self.softButtons = softButtons;
    self.cancelID = cancelID;
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

- (void)setCancelID:(nullable NSNumber<SDLInt> *)cancelID {
    [self.parameters sdl_setObject:cancelID forName:SDLRPCParameterNameCancelID];
}

- (nullable NSNumber<SDLInt> *)cancelID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCancelID ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
