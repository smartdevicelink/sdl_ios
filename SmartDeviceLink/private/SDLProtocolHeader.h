//  SDLProtocolHeader.h
//

#import <Foundation/Foundation.h>

#import "SDLProtocolConstants.h"

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
 *  The data packet's header and payload combination.
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
 *  The session identifier.
 */
@property (assign, nonatomic) UInt8 sessionID;

/**
 *  The payload size differs if the frame type is first frame or single or consecutive frame:
 *  First frame: The data size for a first frame is always 8 bytes. In the payload, the first four bytes denote the total size of the data contained in all consecutive frames, and the second four bytes denote the number of consecutive frames following this one.
 *  Single or consecutive frame: The total bytes in this frame's payload.
 */
@property (assign, nonatomic) UInt32 bytesInPayload;

/**
 *  The initializer for the class.
 *
 *  @return A SDLProtocolHeader object
 */
- (instancetype)init;

/**
 *  Not implemented
 *
 *  @return Unused
 */
- (nullable NSData *)data;

/**
 *  Not implemented
 *
 *  @param data Unused
 */
- (void)parse:(NSData *)data;

/**
 *  Prints a description of the SDLProtocolHeader object.
 *
 *  @return A string description of the SDLProtocolHeader object
 */
- (NSString *)description;

/**
 *  Returns the correct header for the protocol version.
 *
 *  @param version  The protocol version
 *  @return         A SDLProtocolHeader object
 */
+ (__kindof SDLProtocolHeader *)headerForVersion:(UInt8)version;

/**
 *  For use in decoding a stream of bytes.
 *
 *  @param data     Bytes representing message (or beginning of message)
 *  @return         The version number
 */
+ (UInt8)determineVersion:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
