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

 - SDLFrameTypeControl: Lowest-level type of packets. They can be sent over any of the defined services. They are used for the control of the services in which they are sent.
 - SDLFrameTypeSingle: Contains all the data for a particular packet in the payload. The majority of frames sent over the protocol utilize this frame type.
 - SDLFrameTypeFirst: The First Frame in a multiple frame payload contains information about the entire sequence of frames so that the receiving end can correctly parse all the frames and reassemble the entire payload. The payload of this frame is only eight bytes and contains information regarding the rest of the sequence.
 - SDLFrameTypeConsecutive: The Consecutive Frames in a multiple frame payload contain the actual raw data of the original payload. The parsed payload contained in each of the Consecutive Frames' payloads should be buffered until the entire sequence is complete.
 */
typedef NS_ENUM(UInt8, SDLFrameType) {
    SDLFrameTypeControl = 0x00,
    SDLFrameTypeSingle = 0x01,
    SDLFrameTypeFirst = 0x02,
    SDLFrameTypeConsecutive = 0x03
};

/**
 *  The data packet's format and priority.

 - SDLServiceTypeControl: The lowest level service available.
 - SDLServiceTypeRPC: Used to send requests, responses, and notifications between an application and a head unit.
 - SDLServiceTypeAudio: The application can start the audio service to send PCM audio data to the head unit. After the StartService packet is sent and the ACK received, the payload for the Audio Service is only PCM audio data.
 - SDLServiceTypeVideo: The application can start the video service to send H.264 video data to the head unit. After the StartService packet is sent and the ACK received, the payload for the Video Service is only H.264 video data.
 - SDLServiceTypeBulkData: Similar to the RPC Service but adds a bulk data field. The payload of a message sent via the Hybrid service consists of a Binary Header, JSON Data, and Bulk Data.
 */
typedef NS_ENUM(UInt8, SDLServiceType) {
    SDLServiceTypeControl = 0x00,
    SDLServiceTypeRPC NS_SWIFT_NAME(rpc) = 0x07,
    SDLServiceTypeAudio = 0x0A,
    SDLServiceTypeVideo = 0x0B,
    SDLServiceTypeBulkData = 0x0F
};

/**
 *  The data packet's available data.

 - SDLFrameInfoHeartbeat: A ping packet that is sent to ensure the connection is still active and the service is still valid.
 - SDLFrameInfoStartService: Requests that a specific type of service is started.
 - SDLFrameInfoStartServiceACK: Acknowledges that the specific service has been started successfully.
 - SDLFrameInfoStartServiceNACK: Negatively acknowledges that the specific service was not started.
 - SDLFrameInfoEndService: Requests that a specific type of service is ended.
 - SDLFrameInfoEndServiceACK: Acknowledges that the specific service has been ended successfully.
 - SDLFrameInfoEndServiceNACK: Negatively acknowledges that the specific service was not ended or has not yet been started.
 - SDLFrameInfoRegisterSecondaryTransport: Notifies that a Secondary Transport has been established.
 - SDLFrameInfoRegisterSecondaryTransportACK: Acknowledges that the Secondary Transport has been recognized.
 - SDLFrameInfoRegisterSecondaryTransportNACK: Negatively acknowledges that the Secondary Transport has not been recognized.
 - SDLFrameInfoTransportEventUpdate: Indicates the status or configuration of transport(s) is/are updated.
 - SDLFrameInfoServiceDataAck: Deprecated.
 - SDLFrameInfoHeartbeatACK: Acknowledges that a Heartbeat control packet has been received.
 - SDLFrameInfoSingleFrame: Payload contains a single packet.
 - SDLFrameInfoFirstFrame: First frame in a multiple frame payload.
 - SDLFrameInfoConsecutiveLastFrame: Frame in a multiple frame payload.
 */
typedef NS_ENUM(UInt8, SDLFrameInfo) {
    SDLFrameInfoHeartbeat = 0x00,
    SDLFrameInfoStartService = 0x01,
    SDLFrameInfoStartServiceACK = 0x02,
    SDLFrameInfoStartServiceNACK = 0x03,
    SDLFrameInfoEndService = 0x04,
    SDLFrameInfoEndServiceACK = 0x05,
    SDLFrameInfoEndServiceNACK = 0x06,
    SDLFrameInfoRegisterSecondaryTransport = 0x07,
    SDLFrameInfoRegisterSecondaryTransportACK = 0x08,
    SDLFrameInfoRegisterSecondaryTransportNACK = 0x09,
    SDLFrameInfoTransportEventUpdate = 0xFD,
    SDLFrameInfoServiceDataAck = 0xFE,
    SDLFrameInfoHeartbeatACK = 0xFF,
    // If frameType == Single (0x01)
    SDLFrameInfoSingleFrame = 0x00,
    // If frameType == First (0x02)
    SDLFrameInfoFirstFrame = 0x00,
    // If frametype == Consecutive (0x03)
    SDLFrameInfoConsecutiveLastFrame = 0x00
};
