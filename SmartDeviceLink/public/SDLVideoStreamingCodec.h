//
//  SDLVideoStreamingCodec.h
//  SmartDeviceLink-iOS
//

#import "SDLEnum.h"

/**
 * Enum for each type of video streaming codec. Used in VideoStreamingFormat.
 */
typedef SDLEnum SDLVideoStreamingCodec NS_TYPED_ENUM;

/**
 * H264
 */
extern SDLVideoStreamingCodec const SDLVideoStreamingCodecH264;

/**
 * H265
 */
extern SDLVideoStreamingCodec const SDLVideoStreamingCodecH265;

/**
 * Theora
 */
extern SDLVideoStreamingCodec const SDLVideoStreamingCodecTheora;

/**
 * VP8
 */
extern SDLVideoStreamingCodec const SDLVideoStreamingCodecVP8;

/**
 * VP9
 */
extern SDLVideoStreamingCodec const SDLVideoStreamingCodecVP9;
