//  SDLTransportDelegate.h
//
// 

#import <Foundation/Foundation.h>

@protocol SDLTransportDelegate

- (void)onTransportConnected;
- (void)onTransportDisconnected;
- (void)onDataReceived:(NSData *)receivedData;

@end