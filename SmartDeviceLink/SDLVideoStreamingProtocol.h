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
extern SDLVideoStreamingProtocol const SDLVideoStreamingProtocolRAW;

/**
 * @abstract SDLVideoStreamingProtocol : RTP
 */
extern SDLVideoStreamingProtocol const SDLVideoStreamingProtocolRTP;

/**
 * @abstract SDLVideoStreamingProtocol : RTSP
 */
extern SDLVideoStreamingProtocol const SDLVideoStreamingProtocolRTSP;

/**
 * @abstract SDLVideoStreamingProtocol : RTMP
 */
extern SDLVideoStreamingProtocol const SDLVideoStreamingProtocolRTMP;

/**
 * @abstract SDLVideoStreamingProtocol : WebM
 */
extern SDLVideoStreamingProtocol const SDLVideoStreamingProtocolWebM;
