//  SDLSoftButton.h
//

#import "SDLRPCMessage.h"

#import "SDLNotificationConstants.h"
#import "SDLRequestHandler.h"
#import "SDLSoftButtonType.h"
#import "SDLSystemAction.h"

@class SDLImage;

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButton : SDLRPCStruct <SDLRequestHandler>

- (instancetype)initWithHandler:(nullable SDLRPCNotificationHandler)handler;

- (instancetype)initWithType:(SDLSoftButtonType)tyle text:(nullable NSString *)text image:(nullable SDLImage *)image highlighted:(BOOL)highlighted buttonId:(UInt16)buttonId systemAction:(nullable SDLSystemAction)systemAction handler:(nullable SDLRPCNotificationHandler)handler;

@property (copy, nonatomic) SDLRPCNotificationHandler handler;

@property (strong) SDLSoftButtonType type;
@property (nullable, strong) NSString *text;
@property (nullable, strong) SDLImage *image;
@property (nullable, strong) NSNumber<SDLBool> *isHighlighted;
@property (strong) NSNumber<SDLInt> *softButtonID;
@property (nullable, strong) SDLSystemAction systemAction;

@end

NS_ASSUME_NONNULL_END
