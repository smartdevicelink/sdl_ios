//  SDLTransportDelegate.h
//

NS_ASSUME_NONNULL_BEGIN

@protocol SDLTransportDelegate <NSObject>

- (void)onTransportConnected;
- (void)onTransportDisconnected;
- (void)onDataReceived:(NSData *)receivedData;

@end

NS_ASSUME_NONNULL_END
