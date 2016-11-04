//  SDLTurn.h
//

#import "SDLRPCMessage.h"

@class SDLImage;


@interface SDLTurn : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithNavigationText:(NSString *)navigationText turnIcon:(SDLImage *)icon;

@property (strong) NSString *navigationText;
@property (strong) SDLImage *turnIcon;

@end
