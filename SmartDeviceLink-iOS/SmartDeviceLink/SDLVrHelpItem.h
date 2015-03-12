//  SDLVrHelpItem.h
//

#import "SDLRPCMessage.h"

@class SDLImage;


@interface SDLVrHelpItem : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* text;
@property(strong) SDLImage* image;
@property(strong) NSNumber* position;

@end
