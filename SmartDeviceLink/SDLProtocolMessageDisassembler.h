//  SDLSmartDeviceLinkProtocolMessageDisassembler.h
//

#import <Foundation/Foundation.h>

@class SDLProtocolMessage;


@interface SDLProtocolMessageDisassembler : NSObject

+ (NSArray<SDLProtocolMessage *> *)disassemble:(SDLProtocolMessage *)protocolMessage withLimit:(NSUInteger)mtu;

@end
