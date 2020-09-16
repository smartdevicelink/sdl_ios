//  SDLSmartDeviceLinkProtocolMessageDisassembler.h
//

#import <Foundation/Foundation.h>

@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolMessageDisassembler : NSObject

+ (NSArray<SDLProtocolMessage *> *)disassemble:(SDLProtocolMessage *)protocolMessage withLimit:(NSUInteger)mtu;

@end

NS_ASSUME_NONNULL_END
