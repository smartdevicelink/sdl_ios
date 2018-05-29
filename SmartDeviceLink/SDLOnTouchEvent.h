//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

#import "SDLTouchType.h"

@class SDLTouchEvent;

NS_ASSUME_NONNULL_BEGIN

/**
 Notifies about touch events on the screen's prescribed area during video streaming
 */
@interface SDLOnTouchEvent : SDLRPCNotification

/**
 The type of touch event.
 */
@property (strong, nonatomic) SDLTouchType type;

/**
 List of all individual touches involved in this event.
 */
@property (strong, nonatomic) NSArray<SDLTouchEvent *> *event;

@end

NS_ASSUME_NONNULL_END
