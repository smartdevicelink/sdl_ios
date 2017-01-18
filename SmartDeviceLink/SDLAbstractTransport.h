//  SDLAbstractTransport.h

#import <Foundation/Foundation.h>

#import "SDLTransportDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAbstractTransport : NSObject

@property (nullable, weak) id<SDLTransportDelegate> delegate;
@property (strong) NSString *debugConsoleGroupName;

- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)dataToSend;
- (double)retryDelay;

@end

NS_ASSUME_NONNULL_END
