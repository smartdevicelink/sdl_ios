//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

@class SDLTouchEvent;
@class SDLTouchType;

@interface SDLOnTouchEvent : SDLRPCNotification {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) SDLTouchType *type;
@property (strong) NSMutableArray<SDLTouchEvent*> *event;

@end
