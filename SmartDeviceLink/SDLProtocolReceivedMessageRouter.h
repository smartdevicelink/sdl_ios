//  SDLProtocolReceivedMessageRouter.h
//


#import "SDLProtocolListener.h"
@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolReceivedMessageRouter : NSObject

/**
 *  A listener.
 */
@property (weak, nonatomic, nullable) id<SDLProtocolListener> delegate;

/**
 *  Called when a message is received from Core.
 *
 *  @param message A SDLProtocolMessage object
 */
- (void)handleReceivedMessage:(SDLProtocolMessage *)message;

@end

NS_ASSUME_NONNULL_END
