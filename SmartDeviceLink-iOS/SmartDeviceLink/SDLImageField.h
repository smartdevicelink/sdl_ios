//  SDLImageField.h
//



#import "SDLRPCMessage.h"

#import "SDLImageFieldName.h"
#import "SDLImageResolution.h"

@interface SDLImageField : SDLRPCStruct {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLImageFieldName* name;
@property(strong) NSMutableArray* imageTypeSupported;
@property(strong) SDLImageResolution* imageResolution;

@end
