//
//  SDLProtocolConstants.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/1/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  The data packet's header and payload combination.
 */
typedef NS_ENUM(UInt8, SDLFrameType) {
    /// Lowest-level type of packets. They can be sent over any of the defined services. They are used for the control of the services in which they are sent.
    SDLFrameTypeControl = 0x00,

    /// Contains all the data for a particular packet in the payload. The majority of frames sent over the protocol utilize this frame type.
    SDLFrameTypeSingle = 0x01,

    /// The First Frame in a multiple frame payload contains information about the entire sequence of frames so that the receiving end can correctly parse all the frames and reassemble the entire payload. The payload of this frame is only eight bytes and contains information regarding the rest of the sequence.
    SDLFrameTypeFirst = 0x02,

    /// The Consecutive Frames in a multiple frame payload contain the actual raw data of the original payload. The parsed payload contained in each of the Consecutive Frames' payloads should be buffered until the entire sequence is complete.
    SDLFrameTypeConsecutive = 0x03
};

/**
 *  The data packet's format and priority.
 */
typedef NS_ENUM(UInt8, SDLServiceType) {
    /// The lowest level service available.
    SDLServiceTypeControl = 0x00,

    /// Used to send requests, responses, and notifications between an application and a head unit.
    SDLServiceTypeRPC NS_SWIFT_NAME(rpc) = 0x07,

    /// The application can start the audio service to send PCM audio data to the head unit. After the StartService packet is sent and the ACK received, the payload for the Audio Service is only PCM audio data.
    SDLServiceTypeAudio = 0x0A,

    /// The application can start the video service to send H.264 video data to the head unit. After the StartService packet is sent and the ACK received, the payload for the Video Service is only H.264 video data.
    SDLServiceTypeVideo = 0x0B,

    /// Similar to the RPC Service but adds a bulk data field. The payload of a message sent via the Hybrid service consists of a Binary Header, JSON Data, and Bulk Data.
    SDLServiceTypeBulkData = 0x0F
};

/**
 *  The data packet's available data.
 */
typedef NS_ENUM(UInt8, SDLFrameInfo) {
    /// A ping packet that is sent to ensure the connection is still active and the service is still valid.
    SDLFrameInfoHeartbeat = 0x00,

    /// Requests that a specific type of service is started.
    SDLFrameInfoStartService = 0x01,

    /// Acknowledges that the specific service has been started successfully.
    SDLFrameInfoStartServiceACK = 0x02,

    /// Negatively acknowledges that the specific service was not started.
    SDLFrameInfoStartServiceNACK = 0x03,

    /// Requests that a specific type of service is ended.
    SDLFrameInfoEndService = 0x04,

    /// Acknowledges that the specific service has been ended successfully.
    SDLFrameInfoEndServiceACK = 0x05,

    /// Negatively acknowledges that the specific service was not ended or has not yet been started.
    SDLFrameInfoEndServiceNACK = 0x06,

    /// Notifies that a Secondary Transport has been established.
    SDLFrameInfoRegisterSecondaryTransport = 0x07,

    /// Acknowledges that the Secondary Transport has been recognized.
    SDLFrameInfoRegisterSecondaryTransportACK = 0x08,

    /// Negatively acknowledges that the Secondary Transport has not been recognized.
    SDLFrameInfoRegisterSecondaryTransportNACK = 0x09,

    /// Indicates the status or configuration of transport(s) is/are updated.
    SDLFrameInfoTransportEventUpdate = 0xFD,

    /// Deprecated.
    SDLFrameInfoServiceDataAck = 0xFE,

    /// Acknowledges that a Heartbeat control packet has been received.
    SDLFrameInfoHeartbeatACK = 0xFF,

    /// Payload contains a single packet.
    SDLFrameInfoSingleFrame = 0x00, // If frameType == Single (0x01)

    /// First frame in a multiple frame payload.
    SDLFrameInfoFirstFrame = 0x00, // If frameType == First (0x02)

    /// Frame in a multiple frame payload.
    SDLFrameInfoConsecutiveLastFrame = 0x00 // If frametype == Consecutive (0x03)
};
