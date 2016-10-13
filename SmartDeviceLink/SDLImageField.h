//  SDLImageField.h
//

#import "SDLRPCMessage.h"

@class SDLImageFieldName;
@class SDLImageResolution;


@interface SDLImageField : SDLRPCStruct

@property (strong) SDLImageFieldName *name;
@property (strong) NSMutableArray *imageTypeSupported;
@property (strong) SDLImageResolution *imageResolution;

@end
