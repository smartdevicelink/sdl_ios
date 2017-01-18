//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

#import "SDLTouchType.h"

@class SDLTouchEvent;

@interface SDLOnTouchEvent : SDLRPCNotification

@property (strong, nonatomic) SDLTouchType type;
@property (strong, nonatomic) NSMutableArray<SDLTouchEvent *> *event;

@end
