//  SDLSmartDeviceLinkProtocolMessageDisassembler.h
//


#import "SDLProtocolMessage.h"

@interface SDLProtocolMessageDisassembler : NSObject

+ (NSArray *)disassemble:(SDLProtocolMessage *)protocolMessage withLimit:(NSUInteger)mtu;

@end
