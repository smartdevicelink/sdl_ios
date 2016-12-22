//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

#import "SDLTouchType.h"

@class SDLTouchEvent;

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnTouchEvent : SDLRPCNotification

@property (strong) SDLTouchType type;
@property (strong) NSMutableArray<SDLTouchEvent *> *event;

@end

NS_ASSUME_NONNULL_END
