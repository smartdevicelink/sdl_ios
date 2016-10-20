//  SDLOnKeyboardInput.h
//

#import "SDLRPCNotification.h"

#import "SDLKeyboardEvent.h"


@interface SDLOnKeyboardInput : SDLRPCNotification

@property (strong) SDLKeyboardEvent event;
@property (strong) NSString *data;

@end
