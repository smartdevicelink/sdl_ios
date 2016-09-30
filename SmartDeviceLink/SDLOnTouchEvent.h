//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

@class SDLTouchType;


@interface SDLOnTouchEvent : SDLRPCNotification

@property (strong) SDLTouchType *type;
@property (strong) NSMutableArray *event;

@end
