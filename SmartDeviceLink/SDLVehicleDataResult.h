//  SDLVehicleDataResult.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataType;
@class SDLVehicleDataResultCode;


@interface SDLVehicleDataResult : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) SDLVehicleDataType *dataType;
@property (strong) SDLVehicleDataResultCode *resultCode;

@end
