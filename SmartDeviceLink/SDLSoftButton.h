//  SDLSoftButton.h
//

#import "SDLRPCMessage.h"

#import "SDLNotificationConstants.h"
#import "SDLRequestHandler.h"

@class SDLImage;
@class SDLSoftButtonType;
@class SDLSystemAction;


@interface SDLSoftButton : SDLRPCStruct <SDLRequestHandler> {
}

- (instancetype)init;
- (instancetype)initWithHandler:(SDLRPCNotificationHandler)handler;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithType:(SDLSoftButtonType *)tyle text:(NSString *)text image:(SDLImage *)image highlighted:(BOOL)highlighted buttonId:(UInt16)buttonId systemAction:(SDLSystemAction *)systemAction handler:(SDLRPCNotificationHandler)handler;

@property (copy, nonatomic) SDLRPCNotificationHandler handler;

@property (strong) SDLSoftButtonType *type;
@property (strong) NSString *text;
@property (strong) SDLImage *image;
@property (strong) NSNumber *isHighlighted;
@property (strong) NSNumber *softButtonID;
@property (strong) SDLSystemAction *systemAction;

@end
