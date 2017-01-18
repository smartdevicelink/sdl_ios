//  SDLEncodedSyncPData.h
//


#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLEncodedSyncPData : SDLRPCRequest

@property (strong, nonatomic) NSMutableArray<NSString *> *data;

@end

NS_ASSUME_NONNULL_END
