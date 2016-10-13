//  SDLSoftButton.h
//

#import "SDLRPCMessage.h"

#import "SDLNotificationConstants.h"
#import "SDLRequestHandler.h"

@class SDLImage;
@class SDLSoftButtonType;
@class SDLSystemAction;


@interface SDLSoftButton : SDLRPCStruct <SDLRequestHandler>

- (instancetype)initWithHandler:(SDLRPCNotificationHandler)handler;

@property (copy, nonatomic) SDLRPCNotificationHandler handler;

@property (strong) SDLSoftButtonType *type;
@property (strong) NSString *text;
@property (strong) SDLImage *image;
@property (strong) NSNumber *isHighlighted;
@property (strong) NSNumber *softButtonID;
@property (strong) SDLSystemAction *systemAction;

@end
