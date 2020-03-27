//  SDLOnEncodedSyncPData.h
//

#import "SDLRPCNotification.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Callback including encoded data of any SyncP packets that SYNC needs to send back to the mobile device. Legacy / v1 Protocol implementation; responds to EncodedSyncPData. *** DEPRECATED ***
 */
__deprecated
@interface SDLOnEncodedSyncPData : SDLRPCNotification

/**
 Contains base64 encoded string of SyncP packets.
 */
@property (strong, nonatomic) NSArray<NSString *> *data;

/**
 If blank, the SyncP data shall be forwarded to the app. If not blank, the SyncP data shall be forwarded to the provided URL.
 */
@property (nullable, strong, nonatomic) NSString *URL;

/**
 If blank, the SyncP data shall be forwarded to the app. If not blank, the SyncP data shall be forwarded with the provided timeout in seconds.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *Timeout;

@end

NS_ASSUME_NONNULL_END
