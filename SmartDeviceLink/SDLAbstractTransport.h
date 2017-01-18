//  SDLAbstractTransport.h

#import <Foundation/Foundation.h>

#import "SDLTransportDelegate.h"

@interface SDLAbstractTransport : NSObject

@property (weak, nonatomic) id<SDLTransportDelegate> delegate;
@property (strong, nonatomic) NSString *debugConsoleGroupName;

- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)dataToSend;
- (void)dispose;
- (double)retryDelay;

@end
