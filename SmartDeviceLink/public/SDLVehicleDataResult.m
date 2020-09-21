//  SDLVehicleDataResult.m
//

#import "SDLVehicleDataResult.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVehicleDataResult

- (instancetype)initWithDataType:(SDLVehicleDataType)dataType resultCode:(SDLVehicleDataResultCode)resultCode {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.dataType = dataType;
    self.resultCode = resultCode;

    return self;
}

- (instancetype)initWithCustomOEMDataType:(NSString *)customDataType resultCode:(SDLVehicleDataResultCode)resultCode{
    self = [self init];
    if (!self) {
        return nil;
    }

    self.customOEMDataType = customDataType;
    self.resultCode = resultCode;

    return self;
}

- (void)setDataType:(SDLVehicleDataType)dataType {
    [self.store sdl_setObject:dataType forName:SDLRPCParameterNameDataType];
}

- (SDLVehicleDataType)dataType {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameDataType error:&error];
}

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    [self.store sdl_setObject:resultCode forName:SDLRPCParameterNameResultCode];
}

- (SDLVehicleDataResultCode)resultCode {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameResultCode error:&error];
}

- (nullable NSString *)customOEMDataType {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameOEMCustomDataType error:&error];
}

- (void)setCustomOEMDataType:(nullable NSString *)oemCustomDataType {
    [self.store sdl_setObject:oemCustomDataType forName:SDLRPCParameterNameOEMCustomDataType];
}

@end

NS_ASSUME_NONNULL_END
