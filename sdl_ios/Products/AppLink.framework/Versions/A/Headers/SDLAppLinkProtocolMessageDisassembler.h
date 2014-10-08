//  SDLAppLinkProtocolMessageDisassembler.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLAppLinkProtocolMessage.h"

@interface SDLAppLinkProtocolMessageDisassembler : NSObject

+ (NSArray *)disassemble:(SDLAppLinkProtocolMessage *)protocolMessage withLimit:(NSUInteger)mtu;

@end
