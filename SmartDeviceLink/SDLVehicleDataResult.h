//  SDLVehicleDataResult.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataType.h"
#import "SDLVehicleDataResultCode.h"

@interface SDLVehicleDataResult : SDLRPCStruct

@property (strong) SDLVehicleDataType dataType;
@property (strong) SDLVehicleDataResultCode resultCode;

@end
