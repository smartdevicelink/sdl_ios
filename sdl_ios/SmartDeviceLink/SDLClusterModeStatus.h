//  SDLClusterModeStatus.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLPowerModeQualificationStatus.h>
#import <SmartDeviceLink/SDLCarModeStatus.h>
#import <SmartDeviceLink/SDLPowerModeStatus.h>

@interface SDLClusterModeStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* powerModeActive;
@property(strong) SDLPowerModeQualificationStatus* powerModeQualificationStatus;
@property(strong) SDLCarModeStatus* carModeStatus;
@property(strong) SDLPowerModeStatus* powerModeStatus;

@end
