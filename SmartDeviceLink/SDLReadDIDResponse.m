//  SDLReadDIDResponse.m
//


#import "SDLReadDIDResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLDIDResult.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLReadDIDResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameReadDID]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setDidResult:(nullable NSArray<SDLDIDResult *> *)didResult {
    [self.parameters sdl_setObject:didResult forName:SDLRPCParameterNameDIDResult];
}

- (nullable NSArray<SDLDIDResult *> *)didResult {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameDIDResult ofClass:SDLDIDResult.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
