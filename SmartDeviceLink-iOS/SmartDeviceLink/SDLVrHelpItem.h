//  SDLVRHelpItem.h
//



#import "SDLRPCMessage.h"

#import "SDLImage.h"

@interface SDLVRHelpItem : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* text;
@property(strong) SDLImage* image;
@property(strong) NSNumber* position;

@end
