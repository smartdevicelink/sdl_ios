//  SDLProtocolReceivedMessageRouter.h
//


#import "SDLProtocolListener.h"
@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolReceivedMessageRouter : NSObject

@property (weak, nonatomic, nullable) id<SDLProtocolListener> delegate;

- (void)handleReceivedMessage:(SDLProtocolMessage *)message;

@end

NS_ASSUME_NONNULL_END
