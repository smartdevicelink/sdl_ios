//  SDLTurn.h
//



#import "SDLRPCMessage.h"

#import "SDLImage.h"

@interface SDLTurn : SDLRPCStruct {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* navigationText;
@property(strong) SDLImage* turnIcon;

@end
