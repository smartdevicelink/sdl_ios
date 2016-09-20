//  SDLTurn.h
//

#import "SDLRPCMessage.h"

@class SDLImage;


@interface SDLTurn : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) NSString *navigationText;
@property (strong) SDLImage *turnIcon;

@end
