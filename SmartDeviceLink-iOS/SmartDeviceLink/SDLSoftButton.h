//  SDLSoftButton.h
//



#import "SDLRPCMessage.h"

#import "SDLSoftButtonType.h"
#import "SDLImage.h"
#import "SDLSystemAction.h"

@interface SDLSoftButton : SDLRPCStruct {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLSoftButtonType* type;
@property(strong) NSString* text;
@property(strong) SDLImage* image;
@property(strong) NSNumber* isHighlighted;
@property(strong) NSNumber* softButtonID;
@property(strong) SDLSystemAction* systemAction;

@end
