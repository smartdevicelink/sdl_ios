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

@property (copy, nonatomic) SDLRPCNotificationHandler handler;

@property (strong) SDLSoftButtonType type;
@property (strong) NSString *text;
@property (strong) SDLImage *image;
@property (strong) NSNumber *isHighlighted;
@property (strong) NSNumber *softButtonID;
@property (strong) SDLSystemAction systemAction;

@end
