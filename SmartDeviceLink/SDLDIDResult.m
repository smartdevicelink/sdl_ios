//  SDLDIDResult.m
//

#import "SDLDIDResult.h"

#import "SDLNames.h"
#import "SDLVehicleDataResultCode.h"

@implementation SDLDIDResult

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setResultCode:(SDLVehicleDataResultCode *)resultCode {
    if (resultCode != nil) {
        [store setObject:resultCode forKey:SDLNameResultCode];
    } else {
        [store removeObjectForKey:SDLNameResultCode];
    }
}

- (SDLVehicleDataResultCode *)resultCode {
    NSObject *obj = [store objectForKey:SDLNameResultCode];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResultCode.class]) {
        return (SDLVehicleDataResultCode *)obj;
    } else {
        return [SDLVehicleDataResultCode valueOf:(NSString *)obj];
    }
}

- (void)setDidLocation:(NSNumber *)didLocation {
    if (didLocation != nil) {
        [store setObject:didLocation forKey:SDLNameDidLocation];
    } else {
        [store removeObjectForKey:SDLNameDidLocation];
    }
}

- (NSNumber *)didLocation {
    return [store objectForKey:SDLNameDidLocation];
}

- (void)setData:(NSString *)data {
    if (data != nil) {
        [store setObject:data forKey:SDLNameData];
    } else {
        [store removeObjectForKey:SDLNameData];
    }
}

- (NSString *)data {
    return [store objectForKey:SDLNameData];
}

@end
