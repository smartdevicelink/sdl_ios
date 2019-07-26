//  SDLVehicleDataResult.m
//

#import "SDLVehicleDataResult.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVehicleDataResult

- (instancetype)initWithDataType:(SDLVehicleDataType)dataType SDLVehicleDataResultCode:(SDLVehicleDataResultCode)resultCode {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.dataType = dataType;
    self.resultCode = resultCode;

    return self;
}

- (instancetype)initWithCustomDataType:(NSString *)customDataType SDLVehicleDataResultCode:(SDLVehicleDataResultCode)resultCode{
    self = [self init];
    if (!self) {
        return nil;
    }

    self.customDataType = customDataType;
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

- (NSString *)customDataType {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameCustomDataType error:&error];
}

- (void)setCustomDataType:(NSString *)customDataType {
    [self.store sdl_setObject:customDataType forName:SDLRPCParameterNameCustomDataType];
}

@end

NS_ASSUME_NONNULL_END
