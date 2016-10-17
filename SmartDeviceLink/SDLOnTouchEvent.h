//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

@class SDLTouchEvent;
@class SDLTouchType;

@interface SDLOnTouchEvent : SDLRPCNotification

@property (strong) SDLTouchType *type;
@property (strong) NSMutableArray<SDLTouchEvent *> *event;

@end
