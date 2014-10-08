//  SDLSyncProxyFactory.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLProxy.h>

@interface SDLProxyFactory : NSObject {}

+(SDLProxy*) buildSyncProxyWithListener:(NSObject<SDLProxyListener>*) listener;

+(SDLProxy*) buildSyncProxyWithListener:(NSObject<SDLProxyListener>*) listener
                              tcpIPAddress: (NSString*) ipaddress
                                   tcpPort: (NSString*) port;
@end
