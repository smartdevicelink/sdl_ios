//  SDLOnKeyboardInput.h
//

#import "SDLRPCNotification.h"

@class SDLKeyboardEvent;


@interface SDLOnKeyboardInput : SDLRPCNotification {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLKeyboardEvent *event;
@property (strong) NSString *data;

@end
