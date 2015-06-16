//  SDLTransportDelegate.h
//

@protocol SDLTransportDelegate <NSObject>

- (void)onTransportConnected;
- (void)onTransportDisconnected;
- (void)onDataReceived:(NSData *)receivedData;

@end