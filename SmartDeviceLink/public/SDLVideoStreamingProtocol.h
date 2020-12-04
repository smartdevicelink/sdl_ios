//
//  SDLVideoStreamingProtocol.h
//  SmartDeviceLink-iOS
//

#import "SDLEnum.h"

/**
 * Enum for each type of video streaming protocol, used in VideoStreamingFormat
 */
typedef SDLEnum SDLVideoStreamingProtocol NS_TYPED_ENUM;

/**
 * RAW
 */
extern SDLVideoStreamingProtocol const SDLVideoStreamingProtocolRAW;

/**
 * RTP
 */
extern SDLVideoStreamingProtocol const SDLVideoStreamingProtocolRTP;

/**
 * RTSP
 */
extern SDLVideoStreamingProtocol const SDLVideoStreamingProtocolRTSP;

/**
 * RTMP
 */
extern SDLVideoStreamingProtocol const SDLVideoStreamingProtocolRTMP;

/**
 * WebM
 */
extern SDLVideoStreamingProtocol const SDLVideoStreamingProtocolWebM;
