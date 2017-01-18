//  SDLImageField.h
//

#import "SDLRPCMessage.h"

#import "SDLFileType.h"
#import "SDLImageFieldName.h"

@class SDLImageResolution;

NS_ASSUME_NONNULL_BEGIN

@interface SDLImageField : SDLRPCStruct

@property (strong, nonatomic) SDLImageFieldName name;
@property (strong, nonatomic) NSMutableArray<SDLFileType> *imageTypeSupported;
@property (nullable, strong, nonatomic) SDLImageResolution *imageResolution;

@end

NS_ASSUME_NONNULL_END
