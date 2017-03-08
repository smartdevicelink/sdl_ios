//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

#import "SDLTouchType.h"

@class SDLTouchEvent;

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnTouchEvent : SDLRPCNotification

@property (strong, nonatomic) SDLTouchType type;
@property (strong, nonatomic) NSArray<SDLTouchEvent *> *event;

@end

NS_ASSUME_NONNULL_END
