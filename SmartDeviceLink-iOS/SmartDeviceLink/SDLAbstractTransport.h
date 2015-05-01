//  SDLAbstractTransport.h

@import Foundation;

#import "SDLTransportDelegate.h"

@interface SDLAbstractTransport : NSObject

@property (weak) id<SDLTransportDelegate> delegate;
@property (strong) NSString *debugConsoleGroupName;

- (instancetype)init;
- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)dataToSend;
- (void)dispose;
- (double)retryDelay;

@end
