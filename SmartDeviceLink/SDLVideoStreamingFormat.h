//
//  SDLVideoStreamingFormat.h
//  SmartDeviceLink-iOS
//

#import "SDLRPCMessage.h"

@class SDLVideoStreamingCodec;
@class SDLVideoStreamingProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface SDLVideoStreamingFormat : SDLRPCStruct

/**
 * @abstract Constructs a newly allocated SDLVideoStreamingFormat object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLVideoStreamingFormat object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract Protocol type, see VideoStreamingProtocol, mandatory
 */
@property (strong, nonatomic) SDLVideoStreamingProtocol *protocol;

/**
 * @abstract Codec type, see VideoStreamingCodec, mandatory
 */
@property (strong, nonatomic) SDLVideoStreamingCodec *codec;

@end

NS_ASSUME_NONNULL_END
