//  SDLTransportDelegate.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.



@protocol SDLTransportDelegate

- (void)onTransportConnected;
- (void)onTransportDisconnected;
- (void)onDataReceived:(NSData *)receivedData;

@end