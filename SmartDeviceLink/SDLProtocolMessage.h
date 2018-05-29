//  SDLSmartDeviceLinkProtocolMessage.h
//

#import <Foundation/Foundation.h>

@class SDLProtocolHeader;

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolMessage : NSObject

/**
 *  The message's header.
 */
@property (strong, nonatomic) SDLProtocolHeader *header;

/**
 *  The message's payload.
 */
@property (nullable, strong, nonatomic) NSData *payload;

/**
 *  Returns the message's header and payload data.
 */
@property (strong, nonatomic, readonly) NSData *data;

/**
 *  Creates a SDLProtocolMessage object with the provided header and payload.
 *
 *  @param header   A SDLProtocolHeader object
 *  @param payload  The data to be passed in the message
 *  @return         A SDLProtocolMessage object
 */
+ (instancetype)messageWithHeader:(SDLProtocolHeader *)header andPayload:(nullable NSData *)payload; // Returns a V1 or V2 object

/**
 *  Returns the total size of the message.
 *
 *  @return The size of the message
 */
- (NSUInteger)size;

/**
 *  Prints a description of the SDLProtocolMessage object.
 *
 *  @return A string description of the SDLProtocolMessage
 */
- (NSString *)description;

/**
 * Used for RPC type messages to obtain the data in a dictionary.
 *
 *  @return The data in a dictionary
 */
- (nullable NSDictionary<NSString *, id> *)rpcDictionary;

@end

NS_ASSUME_NONNULL_END
