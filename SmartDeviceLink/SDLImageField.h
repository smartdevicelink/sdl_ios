//  SDLImageField.h
//

#import "SDLRPCMessage.h"

#import "SDLFileType.h"
#import "SDLImageFieldName.h"

@class SDLImageResolution;

@interface SDLImageField : SDLRPCStruct

@property (strong) SDLImageFieldName name;
@property (strong) NSMutableArray<SDLFileType> *imageTypeSupported;
@property (strong) SDLImageResolution *imageResolution;

@end
