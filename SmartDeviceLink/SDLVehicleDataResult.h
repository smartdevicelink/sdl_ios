//  SDLVehicleDataResult.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataType.h"
#import "SDLVehicleDataResultCode.h"

@interface SDLVehicleDataResult : SDLRPCStruct

@property (strong, nonatomic) SDLVehicleDataType dataType;
@property (strong, nonatomic) SDLVehicleDataResultCode resultCode;

@end
