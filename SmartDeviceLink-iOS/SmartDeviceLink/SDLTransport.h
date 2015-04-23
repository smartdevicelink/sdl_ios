//  SDLTransport.h
//

@import Foundation;

#import "SDLTransportDelegate.h"


@protocol SDLTransport <NSObject>

@property (weak) id<SDLTransportDelegate> delegate;

- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)dataToSend;

@end
