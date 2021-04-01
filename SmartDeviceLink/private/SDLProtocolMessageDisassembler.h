//  SDLSmartDeviceLinkProtocolMessageDisassembler.h
//

#import <Foundation/Foundation.h>

@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolMessageDisassembler : NSObject

/// Use to break up a large message into a sequence of smaller messages, each of which is less than 'mtu' number of bytes total size.
///
/// @param protocolMessage The message to break up
/// @param mtu The MTU size to use to determine where to break up the message payload
+ (NSArray<SDLProtocolMessage *> *)disassemble:(SDLProtocolMessage *)protocolMessage withPayloadSizeLimit:(NSUInteger)mtu;

@end

NS_ASSUME_NONNULL_END
