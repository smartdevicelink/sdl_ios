//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

#import "SDLTouchType.h"

@interface SDLOnTouchEvent : SDLRPCNotification

@property (strong) SDLTouchType type;
@property (strong) NSMutableArray *event;

@end
