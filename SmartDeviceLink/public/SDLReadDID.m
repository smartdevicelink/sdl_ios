//  SDLReadDID.m
//


#import "SDLReadDID.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLReadDID

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameReadDID]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithECUName:(UInt16)ecuName didLocation:(NSArray<NSNumber<SDLInt> *> *)didLocation {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ecuName = @(ecuName);
    self.didLocation = [didLocation mutableCopy];

    return self;
}

- (void)setEcuName:(NSNumber<SDLInt> *)ecuName {
    [self.parameters sdl_setObject:ecuName forName:SDLRPCParameterNameECUName];
}

- (NSNumber<SDLInt> *)ecuName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameECUName ofClass:NSNumber.class error:&error];
}

- (void)setDidLocation:(NSArray<NSNumber *> *)didLocation {
    [self.parameters sdl_setObject:didLocation forName:SDLRPCParameterNameDIDLocation];
}

- (NSArray<NSNumber *> *)didLocation {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameDIDLocation ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
