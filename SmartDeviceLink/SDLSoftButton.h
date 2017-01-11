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

@property (strong) SDLSoftButtonType type;
@property (strong) NSString *text;
@property (strong) SDLImage *image;
@property (strong) NSNumber<SDLBool> *isHighlighted;
@property (strong) NSNumber<SDLInt> *softButtonID;
@property (strong) SDLSystemAction systemAction;

@end
