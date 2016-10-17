//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

#import "SDLTouchType.h"

@class SDLTouchEvent;

@interface SDLOnTouchEvent : SDLRPCNotification

@property (strong) SDLTouchType type;
@property (strong) NSMutableArray<SDLTouchEvent *> *event;

@end
