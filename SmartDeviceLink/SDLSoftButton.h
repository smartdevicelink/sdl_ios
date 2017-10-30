//  SDLSoftButton.h
//

#import "SDLRPCMessage.h"

#import "SDLNotificationConstants.h"
#import "SDLSoftButtonType.h"
#import "SDLSystemAction.h"

@class SDLImage;

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButton : SDLRPCStruct

- (instancetype)initWithHandler:(nullable SDLRPCButtonNotificationHandler)handler;

- (instancetype)initWithType:(SDLSoftButtonType)type text:(nullable NSString *)text image:(nullable SDLImage *)image highlighted:(BOOL)highlighted buttonId:(UInt16)buttonId systemAction:(nullable SDLSystemAction)systemAction handler:(nullable SDLRPCButtonNotificationHandler)handler;

@property (copy, nonatomic) SDLRPCButtonNotificationHandler handler;

@property (strong, nonatomic) SDLSoftButtonType type;
@property (strong, nonatomic, nullable) NSString *text;
@property (strong, nonatomic, nullable) SDLImage *image;
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *isHighlighted;
@property (strong, nonatomic) NSNumber<SDLInt> *softButtonID;
@property (strong, nonatomic, nullable) SDLSystemAction systemAction;

@end

NS_ASSUME_NONNULL_END
