//  SDLImageField.h
//

#import "SDLRPCMessage.h"

#import "SDLFileType.h"
#import "SDLImageFieldName.h"

@class SDLImageResolution;

@interface SDLImageField : SDLRPCStruct

@property (strong, nonatomic) SDLImageFieldName name;
@property (strong, nonatomic) NSMutableArray<SDLFileType> *imageTypeSupported;
@property (strong, nonatomic) SDLImageResolution *imageResolution;

@end
