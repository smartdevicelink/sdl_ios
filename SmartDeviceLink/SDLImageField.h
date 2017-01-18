//  SDLImageField.h
//

#import "SDLRPCMessage.h"

#import "SDLFileType.h"
#import "SDLImageFieldName.h"

@class SDLImageResolution;

NS_ASSUME_NONNULL_BEGIN

@interface SDLImageField : SDLRPCStruct

@property (strong) SDLImageFieldName name;
@property (strong) NSMutableArray<SDLFileType> *imageTypeSupported;
@property (nullable, strong) SDLImageResolution *imageResolution;

@end

NS_ASSUME_NONNULL_END
