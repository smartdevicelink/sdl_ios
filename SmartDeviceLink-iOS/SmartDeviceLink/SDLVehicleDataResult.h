//  SDLVehicleDataResult.h
//


#import "SDLRPCMessage.h"

#import "SDLVehicleDataType.h"
#import "SDLVehicleDataResultCode.h"

@interface SDLVehicleDataResult : SDLRPCStruct {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLVehicleDataType *dataType;
@property (strong) SDLVehicleDataResultCode *resultCode;

@end
