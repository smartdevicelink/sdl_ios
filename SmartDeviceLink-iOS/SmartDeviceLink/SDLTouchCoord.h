//  SDLTouchCoord.h
//


#import "SDLRPCMessage.h"

@interface SDLTouchCoord : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSNumber *x;
@property (strong) NSNumber *y;

@end
