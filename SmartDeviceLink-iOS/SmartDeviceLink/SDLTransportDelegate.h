//  SDLTransportDelegate.h
//

@protocol SDLTransportDelegate

- (void)onTransportConnected;
- (void)onTransportDisconnected;
- (void)onDataReceived:(NSData *)receivedData;

@end