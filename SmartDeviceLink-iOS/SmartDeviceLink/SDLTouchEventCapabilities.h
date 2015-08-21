//  SDLTouchEventCapabilities.h
//


#import "SDLRPCMessage.h"

@interface SDLTouchEventCapabilities : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSNumber *pressAvailable;
@property (strong) NSNumber *multiTouchAvailable;
@property (strong) NSNumber *doublePressAvailable;

@end
