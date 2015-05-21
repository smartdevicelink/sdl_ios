//  SDLSmartDeviceLinkProtocolMessageDisassembler.h
//

@import Foundation;

@class SDLProtocolMessage;


@interface SDLProtocolMessageDisassembler : NSObject

+ (NSArray *)disassemble:(SDLProtocolMessage *)protocolMessage withLimit:(NSUInteger)mtu;

@end
