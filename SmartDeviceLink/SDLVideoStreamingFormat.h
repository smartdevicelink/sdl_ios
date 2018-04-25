//
//  SDLVideoStreamingFormat.h
//  SmartDeviceLink-iOS
//

#import "SDLRPCMessage.h"
#import "SDLVideoStreamingProtocol.h"
#import "SDLVideoStreamingCodec.h"

NS_ASSUME_NONNULL_BEGIN

/**
 An available format for video streaming in projection applications
 */
@interface SDLVideoStreamingFormat : SDLRPCStruct

/**
 Protocol type, see VideoStreamingProtocol

 Required
 */
@property (strong, nonatomic) SDLVideoStreamingProtocol protocol;

/**
 Codec type, see VideoStreamingCodec

 Required
 */
@property (strong, nonatomic) SDLVideoStreamingCodec codec;

- (instancetype)initWithCodec:(SDLVideoStreamingCodec)codec protocol:(SDLVideoStreamingProtocol)protocol;

@end

NS_ASSUME_NONNULL_END
