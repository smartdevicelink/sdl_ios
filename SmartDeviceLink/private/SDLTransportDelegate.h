//  SDLTransportDelegate.h
//

NS_ASSUME_NONNULL_BEGIN

@protocol SDLTransportDelegate <NSObject>

/**
 *  The transport connected to Core
 */
- (void)onTransportConnected;

/**
 *  The transport disconnected from Core
 */
- (void)onTransportDisconnected;

/**
 *  Data received from Core
 *
 *  @param receivedData The data received from Core
 */
- (void)onDataReceived:(NSData *)receivedData;
- (void)onError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
