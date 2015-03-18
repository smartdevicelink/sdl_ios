//  SDLTireStatus.h
//


#import "SDLRPCMessage.h"

#import "SDLWarningLightStatus.h"
#import "SDLSingleTireStatus.h"

@interface SDLTireStatus : SDLRPCStruct {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLWarningLightStatus *pressureTelltale;
@property (strong) SDLSingleTireStatus *leftFront;
@property (strong) SDLSingleTireStatus *rightFront;
@property (strong) SDLSingleTireStatus *leftRear;
@property (strong) SDLSingleTireStatus *rightRear;
@property (strong) SDLSingleTireStatus *innerLeftRear;
@property (strong) SDLSingleTireStatus *innerRightRear;

@end
