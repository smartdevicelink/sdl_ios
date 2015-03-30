//  SDLVrHelpItem.h
//



#import "SDLRPCMessage.h"

#import "SDLImage.h"

@interface SDLVrHelpItem : SDLRPCStruct {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* text;
@property(strong) SDLImage* image;
@property(strong) NSNumber* position;

@end
