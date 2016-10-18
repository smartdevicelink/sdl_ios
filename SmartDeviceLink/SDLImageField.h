//  SDLImageField.h
//

#import "SDLRPCMessage.h"

@class SDLFileType;
@class SDLImageFieldName;
@class SDLImageResolution;

@interface SDLImageField : SDLRPCStruct

@property (strong) SDLImageFieldName *name;
@property (strong) NSMutableArray<SDLFileType *> *imageTypeSupported;
@property (strong) SDLImageResolution *imageResolution;

@end
