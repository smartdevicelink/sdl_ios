//  SDLImageResolution.h
//


#import "SDLRPCMessage.h"

@interface SDLImageResolution : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) NSNumber *resolutionWidth;
@property (strong) NSNumber *resolutionHeight;

@end
