//  SDLTouchEvent.h
//



#import "SDLRPCMessage.h"

@interface SDLTouchEvent : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* touchEventId;
@property(strong) NSMutableArray* timeStamp;
@property(strong) NSMutableArray* coord;

@end
