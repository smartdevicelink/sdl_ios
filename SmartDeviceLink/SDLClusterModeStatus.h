//  SDLClusterModeStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLCarModeStatus.h"
#import "SDLPowerModeQualificationStatus.h"
#import "SDLPowerModeStatus.h"


@interface SDLClusterModeStatus : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSNumber *powerModeActive;
@property (strong) SDLPowerModeQualificationStatus powerModeQualificationStatus;
@property (strong) SDLCarModeStatus carModeStatus;
@property (strong) SDLPowerModeStatus powerModeStatus;

@end
