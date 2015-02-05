//  SDLSmartDeviceLinkProtocolMessageDisassembler.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLProtocolMessage.h"

@interface SDLProtocolMessageDisassembler : NSObject

+ (NSArray *)disassemble:(SDLProtocolMessage *)protocolMessage withLimit:(NSUInteger)mtu;

@end
