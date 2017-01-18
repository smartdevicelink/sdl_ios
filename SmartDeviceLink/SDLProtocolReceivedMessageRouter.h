//  SDLProtocolReceivedMessageRouter.h
//


#import "SDLProtocolListener.h"
@class SDLProtocolMessage;


@interface SDLProtocolReceivedMessageRouter : NSObject

@property (weak, nonatomic) id<SDLProtocolListener> delegate;

- (void)handleReceivedMessage:(SDLProtocolMessage *)message;

@end
