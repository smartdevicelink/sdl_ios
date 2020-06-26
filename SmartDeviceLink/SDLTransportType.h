//  SDLTransportType.h

#import <Foundation/Foundation.h>

#import "SDLTransportDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SDLTransportType <NSObject>

@property (nullable, weak, nonatomic) id<SDLTransportDelegate> delegate;

- (void)connect;
- (void)disconnectWithCompletionHandler:(void (^)(void))disconnectCompletionHandler;
- (void)sendData:(NSData *)dataToSend;

@end

NS_ASSUME_NONNULL_END
