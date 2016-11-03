//  SDLTurn.h
//

#import "SDLRPCMessage.h"

@class SDLImage;


@interface SDLTurn : SDLRPCStruct

- (instancetype)initWithNavigationText:(NSString *)navigationText turnIcon:(SDLImage *)icon;

@property (strong) NSString *navigationText;
@property (strong) SDLImage *turnIcon;

@end
