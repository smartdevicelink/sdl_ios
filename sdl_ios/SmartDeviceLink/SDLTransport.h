//  SDLTransport.h
//
//  

#import <Foundation/Foundation.h>
#import "SDLTransportDelegate.h"

@protocol SDLTransport

@property (weak) id<SDLTransportDelegate> delegate;

- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)dataToSend;
- (void)unregister;

@end
