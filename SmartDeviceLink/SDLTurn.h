//  SDLTurn.h
//

#import "SDLRPCMessage.h"

@class SDLImage;


@interface SDLTurn : SDLRPCStruct

@property (strong) NSString *navigationText;
@property (strong) SDLImage *turnIcon;

@end
