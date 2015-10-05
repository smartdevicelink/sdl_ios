//  SDLEncodedSyncPData.h
//


#import "SDLRPCRequest.h"

@interface SDLEncodedSyncPData : SDLRPCRequest {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSMutableArray *data;

@end
