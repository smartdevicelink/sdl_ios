//  SDLSoftButton.h
//

#import "SDLRPCMessage.h"

@class SDLImage;
@class SDLSoftButtonType;
@class SDLSystemAction;


@interface SDLSoftButton : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLSoftButtonType *type;
@property (strong) NSString *text;
@property (strong) SDLImage *image;
@property (strong) NSNumber *isHighlighted;
@property (strong) NSNumber *softButtonID;
@property (strong) SDLSystemAction *systemAction;

@end
