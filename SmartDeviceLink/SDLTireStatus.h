//  SDLTireStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLWarningLightStatus.h"

@class SDLSingleTireStatus;

NS_ASSUME_NONNULL_BEGIN

@interface SDLTireStatus : SDLRPCStruct

@property (strong, nonatomic) SDLWarningLightStatus pressureTelltale;
@property (strong, nonatomic) SDLSingleTireStatus *leftFront;
@property (strong, nonatomic) SDLSingleTireStatus *rightFront;
@property (strong, nonatomic) SDLSingleTireStatus *leftRear;
@property (strong, nonatomic) SDLSingleTireStatus *rightRear;
@property (strong, nonatomic) SDLSingleTireStatus *innerLeftRear;
@property (strong, nonatomic) SDLSingleTireStatus *innerRightRear;

@end

NS_ASSUME_NONNULL_END
