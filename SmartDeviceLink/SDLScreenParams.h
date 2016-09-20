//  SDLScreenParams.h
//

#import "SDLRPCMessage.h"

@class SDLImageResolution;
@class SDLTouchEventCapabilities;


@interface SDLScreenParams : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) SDLImageResolution *resolution;
@property (strong) SDLTouchEventCapabilities *touchEventAvailable;

@end
