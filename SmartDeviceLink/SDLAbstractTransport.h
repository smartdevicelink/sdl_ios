//  SDLAbstractTransport.h

#import <Foundation/Foundation.h>

#import "SDLTransportDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAbstractTransport : NSObject

@property (weak) id<SDLTransportDelegate> delegate;
@property (strong) NSString *debugConsoleGroupName;

- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)dataToSend;
- (void)dispose;
- (double)retryDelay;

@end

NS_ASSUME_NONNULL_END
