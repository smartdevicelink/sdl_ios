//  SDLVehicleDataResult.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataType.h"
#import "SDLVehicleDataResultCode.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLVehicleDataResult : SDLRPCStruct

@property (strong) SDLVehicleDataType dataType;
@property (strong) SDLVehicleDataResultCode resultCode;

@end

NS_ASSUME_NONNULL_END
