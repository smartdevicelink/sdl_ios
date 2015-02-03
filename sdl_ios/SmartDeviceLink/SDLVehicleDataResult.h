//  SDLVehicleDataResult.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLVehicleDataType.h>
#import <SmartDeviceLink/SDLVehicleDataResultCode.h>

@interface SDLVehicleDataResult : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataType* dataType;
@property(strong) SDLVehicleDataResultCode* resultCode;

@end
