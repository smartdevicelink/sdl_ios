//  SDLSmartDeviceLinkProtocolMessageDisassembler.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLProtocolMessage.h"

@interface SDLProtocolMessageDisassembler : NSObject

+ (NSArray *)disassemble:(SDLProtocolMessage *)protocolMessage withLimit:(NSUInteger)mtu;

@end
