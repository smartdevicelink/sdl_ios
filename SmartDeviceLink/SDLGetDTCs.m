//  SDLGetDTCs.m
//


#import "SDLGetDTCs.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetDTCs

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetDTCs]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithECUName:(UInt16)name mask:(UInt8)mask {
    self = [self initWithECUName:name];
    if (!self) {
        return nil;
    }

    self.dtcMask = @(mask);

    return self;
}

- (instancetype)initWithECUName:(UInt16)name {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ecuName = @(name);

    return self;
}

- (void)setEcuName:(NSNumber<SDLInt> *)ecuName {
    [self.parameters sdl_setObject:ecuName forName:SDLRPCParameterNameECUName];
}

- (NSNumber<SDLInt> *)ecuName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameECUName ofClass:NSNumber.class error:&error];
}

- (void)setDtcMask:(nullable NSNumber<SDLInt> *)dtcMask {
    [self.parameters sdl_setObject:dtcMask forName:SDLRPCParameterNameDTCMask];
}

- (nullable NSNumber<SDLInt> *)dtcMask {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDTCMask ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
