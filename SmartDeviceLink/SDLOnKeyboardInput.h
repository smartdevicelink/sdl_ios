//  SDLOnKeyboardInput.h
//

#import "SDLRPCNotification.h"

@class SDLKeyboardEvent;


@interface SDLOnKeyboardInput : SDLRPCNotification

@property (strong) SDLKeyboardEvent *event;
@property (strong) NSString *data;

@end
