//  SDLVehicleDataResult.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataType;
@class SDLVehicleDataResultCode;


@interface SDLVehicleDataResult : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataType* dataType;
@property(strong) SDLVehicleDataResultCode* resultCode;

@end
