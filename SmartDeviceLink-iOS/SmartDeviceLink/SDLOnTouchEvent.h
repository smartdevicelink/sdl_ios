//  SDLOnTouchEvent.h
//


#import "SDLRPCNotification.h"

#import "SDLTouchType.h"

@interface SDLOnTouchEvent : SDLRPCNotification {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLTouchType *type;
@property (strong) NSMutableArray *event;

@end
