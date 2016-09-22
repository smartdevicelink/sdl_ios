//  SDLVehicleDataResult.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataType;
@class SDLVehicleDataResultCode;


@interface SDLVehicleDataResult : SDLRPCStruct

@property (strong) SDLVehicleDataType *dataType;
@property (strong) SDLVehicleDataResultCode *resultCode;

@end
