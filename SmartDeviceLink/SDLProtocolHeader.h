//  SDLProtocolHeader.h
//

#import <Foundation/Foundation.h>


/**
 *  The packet's header and payload combination.

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
 *  The packet's format and priority.

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
 *  The packet's available data.

 - SDLFrameInfoHeartbeat: A ping packet that is sent to ensure the connection is still active and the service is still valid.
 - SDLFrameInfoStartService: Requests that a specific type of service is started.
 - SDLFrameInfoStartServiceACK: Acknowledges that the specific service has been started successfully.
 - SDLFrameInfoStartServiceNACK: Negatively acknowledges that the specific service was not started.
 - SDLFrameInfoEndService: Requests that a specific type of service is ended.
 - SDLFrameInfoEndServiceACK: Acknowledges that the specific service has been ended successfully.
 - SDLFrameInfoEndServiceNACK: Negatively acknowledges that the specific service was not ended or has not yet been started.
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
    SDLFrameInfoServiceDataAck = 0xFE,
    SDLFrameInfoHeartbeatACK = 0xFF,
    // If frameType == Single (0x01)
    SDLFrameInfoSingleFrame = 0x00,
    // If frameType == First (0x02)
    SDLFrameInfoFirstFrame = 0x00,
    // If frametype == Consecutive (0x03)
    SDLFrameInfoConsecutiveLastFrame = 0x00
};

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolHeader : NSObject <NSCopying> {
    UInt8 _version;
    NSUInteger _size;
}

/**
 *  The protocol version. The frame header differs between versions.
 */
@property (assign, nonatomic, readonly) UInt8 version;

/**
 *  The total size of the data packet.
 */
@property (assign, nonatomic, readonly) NSUInteger size;

/**
 *  Whether or not the data packet is encrypted.
 *
 *  @note Only available in Protocol Version 2 and higher.
 */
@property (assign, nonatomic) BOOL encrypted;

/**
 *  The data packet's header and payload combination
 */
@property (assign, nonatomic) SDLFrameType frameType;

/**
 *  The data packet's payload format and priority. Lower values for service type have higher delivery priority.
 */
@property (assign, nonatomic) SDLServiceType serviceType;

/**
 *  The type of data in the packet. This differs based on the control frame type and the service type.
 */
@property (assign, nonatomic) SDLFrameInfo frameData;

/**
 *  The session identifier
 */
@property (assign, nonatomic) UInt8 sessionID;

/**
 *  The payload size differs if the frame type is first frame or single or consecutive frame:
 *  First frame: The data size for a first frame is always 8 bytes. In the payload, the first four bytes denote the total size of the data contained in all consecutive frames, and the second four bytes denote the number of consecutive frames following this one.
 *  Single or consecutive frame: The total bytes in this frame's payload.
 */
@property (assign, nonatomic) UInt32 bytesInPayload;

- (instancetype)init;
- (nullable NSData *)data;
- (void)parse:(NSData *)data;
- (NSString *)description;
+ (__kindof SDLProtocolHeader *)headerForVersion:(UInt8)version;
+ (UInt8)determineVersion:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
