//  SDLTurn.h
//

#import "SDLRPCMessage.h"

@class SDLImage;


@interface SDLTurn : SDLRPCStruct

- (instancetype)initWithNavigationText:(NSString *)navigationText turnIcon:(SDLImage *)icon;

@property (strong, nonatomic) NSString *navigationText;
@property (strong, nonatomic) SDLImage *turnIcon;

@end
