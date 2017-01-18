//  SDLTireStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLWarningLightStatus.h"

@class SDLSingleTireStatus;

NS_ASSUME_NONNULL_BEGIN

@interface SDLTireStatus : SDLRPCStruct

@property (strong) SDLWarningLightStatus pressureTelltale;
@property (strong) SDLSingleTireStatus *leftFront;
@property (strong) SDLSingleTireStatus *rightFront;
@property (strong) SDLSingleTireStatus *leftRear;
@property (strong) SDLSingleTireStatus *rightRear;
@property (strong) SDLSingleTireStatus *innerLeftRear;
@property (strong) SDLSingleTireStatus *innerRightRear;

@end

NS_ASSUME_NONNULL_END
