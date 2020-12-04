//  SDLProtocolReceivedMessageRouter.h
//


#import "SDLProtocolDelegate.h"
@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolReceivedMessageRouter : NSObject

/**
 *  A listener.
 */
@property (weak, nonatomic, nullable) id<SDLProtocolDelegate> delegate;

/**
 *  Called when a message is received from Core.
 *
 *  @param message A SDLProtocolMessage object
 */
- (void)handleReceivedMessage:(SDLProtocolMessage *)message protocol:(SDLProtocol *)protocol;

@end

NS_ASSUME_NONNULL_END
