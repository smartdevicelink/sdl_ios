//  SDLImageField.h
//

#import "SDLRPCMessage.h"

@class SDLImageFieldName;
@class SDLImageResolution;


@interface SDLImageField : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLImageFieldName* name;
@property(strong) NSMutableArray* imageTypeSupported;
@property(strong) SDLImageResolution* imageResolution;

@end
