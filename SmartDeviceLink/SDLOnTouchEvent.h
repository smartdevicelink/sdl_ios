//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

#import "SDLTouchType.h"

@interface SDLOnTouchEvent : SDLRPCNotification {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLTouchType type;
@property (strong) NSMutableArray *event;

@end
