//  SDLOnKeyboardInput.h
//

#import "SDLRPCNotification.h"

#import "SDLKeyboardEvent.h"


@interface SDLOnKeyboardInput : SDLRPCNotification

@property (strong, nonatomic) SDLKeyboardEvent event;
@property (strong, nonatomic) NSString *data;

@end
