//  SDLImageField.h
//

#import "SDLRPCMessage.h"

#import "SDLImageFieldName.h"

@class SDLImageResolution;


@interface SDLImageField : SDLRPCStruct

@property (strong) SDLImageFieldName name;
@property (strong) NSMutableArray *imageTypeSupported;
@property (strong) SDLImageResolution *imageResolution;

@end
