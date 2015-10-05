//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

@class SDLTouchType;


@interface SDLOnTouchEvent : SDLRPCNotification {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLTouchType *type;
@property (strong) NSMutableArray *event;

@end
