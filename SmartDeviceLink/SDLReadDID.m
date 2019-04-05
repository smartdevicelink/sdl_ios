//  SDLReadDID.m
//


#import "SDLReadDID.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLReadDID

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameReadDID]) {
    }
    return self;
}

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
    [parameters sdl_setObject:ecuName forName:SDLRPCParameterNameECUName];
}

- (NSNumber<SDLInt> *)ecuName {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameECUName ofClass:NSNumber.class error:&error];
}

- (void)setDidLocation:(NSArray<NSNumber<SDLInt> *> *)didLocation {
    [parameters sdl_setObject:didLocation forName:SDLRPCParameterNameDIDLocation];
}

- (NSArray<NSNumber<SDLInt> *> *)didLocation {
    NSError *error = nil;
    return [parameters sdl_objectsForName:SDLRPCParameterNameDIDLocation ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
