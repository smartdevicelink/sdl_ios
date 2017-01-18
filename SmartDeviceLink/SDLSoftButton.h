//  SDLSoftButton.h
//

#import "SDLRPCMessage.h"

#import "SDLNotificationConstants.h"
#import "SDLRequestHandler.h"
#import "SDLSoftButtonType.h"
#import "SDLSystemAction.h"

@class SDLImage;


@interface SDLSoftButton : SDLRPCStruct <SDLRequestHandler>

- (instancetype)initWithHandler:(SDLRPCNotificationHandler)handler;

- (instancetype)initWithType:(SDLSoftButtonType)type text:(NSString *)text image:(SDLImage *)image highlighted:(BOOL)highlighted buttonId:(UInt16)buttonId systemAction:(SDLSystemAction)systemAction handler:(SDLRPCNotificationHandler)handler;

@property (copy, nonatomic) SDLRPCNotificationHandler handler;

@property (strong, nonatomic) SDLSoftButtonType type;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) SDLImage *image;
@property (strong, nonatomic) NSNumber<SDLBool> *isHighlighted;
@property (strong, nonatomic) NSNumber<SDLInt> *softButtonID;
@property (strong, nonatomic) SDLSystemAction systemAction;

@end
