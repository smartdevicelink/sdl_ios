//  SDLOnKeyboardInput.h
//

#import "SDLRPCNotification.h"

@class SDLKeyboardEvent;


@interface SDLOnKeyboardInput : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLKeyboardEvent* event;
@property(strong) NSString* data;

@end
