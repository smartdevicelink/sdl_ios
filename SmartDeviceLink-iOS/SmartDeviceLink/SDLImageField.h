//  SDLImageField.h
//

#import "SDLRPCMessage.h"

@class SDLImageFieldName;
@class SDLImageResolution;


@interface SDLImageField : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLImageFieldName *name;
@property (strong) NSMutableArray *imageTypeSupported;
@property (strong) SDLImageResolution *imageResolution;

@end
