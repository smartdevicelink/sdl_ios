//  SDLVehicleDataResult.h
//



#import "SDLRPCMessage.h"

#import "SDLVehicleDataType.h"
#import "SDLVehicleDataResultCode.h"

@interface SDLVehicleDataResult : SDLRPCStruct {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataType* dataType;
@property(strong) SDLVehicleDataResultCode* resultCode;

@end
