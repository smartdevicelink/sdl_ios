//  SDLClusterModeStatus.h
//

#import "SDLRPCMessage.h"

@class SDLCarModeStatus;
@class SDLPowerModeQualificationStatus;
@class SDLPowerModeStatus;


@interface SDLClusterModeStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* powerModeActive;
@property(strong) SDLPowerModeQualificationStatus* powerModeQualificationStatus;
@property(strong) SDLCarModeStatus* carModeStatus;
@property(strong) SDLPowerModeStatus* powerModeStatus;

@end
