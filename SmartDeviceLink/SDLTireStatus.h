//  SDLTireStatus.h
//

#import "SDLRPCMessage.h"

@class SDLSingleTireStatus;
@class SDLWarningLightStatus;


@interface SDLTireStatus : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLWarningLightStatus *pressureTelltale;
@property (strong) SDLSingleTireStatus *leftFront;
@property (strong) SDLSingleTireStatus *rightFront;
@property (strong) SDLSingleTireStatus *leftRear;
@property (strong) SDLSingleTireStatus *rightRear;
@property (strong) SDLSingleTireStatus *innerLeftRear;
@property (strong) SDLSingleTireStatus *innerRightRear;

@end
