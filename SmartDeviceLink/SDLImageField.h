//  SDLImageField.h
//

#import "SDLRPCMessage.h"

@class SDLImageFieldName;
@class SDLImageResolution;
@class SDLFileType;


@interface SDLImageField : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) SDLImageFieldName *name;
@property (strong) NSMutableArray<SDLFileType *> *imageTypeSupported;
@property (strong) SDLImageResolution *imageResolution;

@end
