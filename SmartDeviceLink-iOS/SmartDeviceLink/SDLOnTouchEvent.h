//  SDLOnTouchEvent.h
//

#import "SDLRPCNotification.h"

@class SDLTouchType;


@interface SDLOnTouchEvent : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLTouchType* type;
@property(strong) NSMutableArray* event;

@end
