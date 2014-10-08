//  SDLTransportDelegate.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>

@protocol SDLTransportDelegate

- (void)onTransportConnected;
- (void)onTransportDisconnected;
- (void)onDataReceived:(NSData *)receivedData;

@end