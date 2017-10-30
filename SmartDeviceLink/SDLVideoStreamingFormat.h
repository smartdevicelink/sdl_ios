//
//  SDLVideoStreamingFormat.h
//  SmartDeviceLink-iOS
//

#import "SDLRPCMessage.h"
#import "SDLVideoStreamingProtocol.h"
#import "SDLVideoStreamingCodec.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLVideoStreamingFormat : SDLRPCStruct

/**
 * @abstract Protocol type, see VideoStreamingProtocol, mandatory
 */
@property (strong, nonatomic) SDLVideoStreamingProtocol protocol;

/**
 * @abstract Codec type, see VideoStreamingCodec, mandatory
 */
@property (strong, nonatomic) SDLVideoStreamingCodec codec;

- (instancetype)initWithCodec:(SDLVideoStreamingCodec)codec protocol:(SDLVideoStreamingProtocol)protocol;

@end

NS_ASSUME_NONNULL_END
