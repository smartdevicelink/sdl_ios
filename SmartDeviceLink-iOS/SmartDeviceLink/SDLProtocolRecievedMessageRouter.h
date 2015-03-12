//  SDLProtocolRecievedMessageRouter.h
//

#import "SDLProtocolListener.h"

@class SDLProtocolMessage;


@interface SDLProtocolRecievedMessageRouter : NSObject

@property (weak) id<SDLProtocolListener> delegate;

- (void)handleRecievedMessage:(SDLProtocolMessage *)message;

@end
