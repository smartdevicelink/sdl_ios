//  SDLEncodedSyncPData.h
//


#import "SDLRPCRequest.h"

/**
 *  Allows encoded data in the form of SyncP packets to be sent to the SYNC module. Legacy / v1 Protocol implementation; use SyncPData instead.
 *
 *  *** DEPRECATED ***
 */

NS_ASSUME_NONNULL_BEGIN

__deprecated
@interface SDLEncodedSyncPData : SDLRPCRequest

/**
 *  Contains base64 encoded string of SyncP packets.
 *
 *  Required, Array length 1 - 100, String length 1 - 1,000,000
 *
 *  @see SDLTTSChunk
 */
@property (strong, nonatomic) NSArray<NSString *> *data;

@end

NS_ASSUME_NONNULL_END
