//  SDLEncodedSyncPData.h
//


#import "SDLRPCRequest.h"

@interface SDLEncodedSyncPData : SDLRPCRequest

@property (strong, nonatomic) NSMutableArray<NSString *> *data;

@end
