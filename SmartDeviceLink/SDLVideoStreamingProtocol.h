//
//  SDLVideoStreamingProtocol.h
//  SmartDeviceLink-iOS
//

#import "SDLEnum.h"

/**
 * Enum for each type of video streaming protocol
 */
typedef SDLEnum SDLVideoStreamingProtocol SDL_SWIFT_ENUM;

/**
 * @abstract SDLVideoStreamingProtocol : RAW
 */
extern SDLVideoStreamingProtocol const RAW;

/**
 * @abstract SDLVideoStreamingProtocol : RTP
 */
extern SDLVideoStreamingProtocol const RTP;

/**
 * @abstract SDLVideoStreamingProtocol : RTSP
 */
extern SDLVideoStreamingProtocol const RTSP;

/**
 * @abstract SDLVideoStreamingProtocol : RTMP
 */
extern SDLVideoStreamingProtocol const RTMP;

/**
 * @abstract SDLVideoStreamingProtocol : WEBM
 */
extern SDLVideoStreamingProtocol const WEBM;
