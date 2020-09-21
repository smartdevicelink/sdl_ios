//  SDLOnHashChange.h
//


#import "SDLRPCNotification.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Notification containing an updated hashID which can be used over connection cycles (i.e. loss of connection, ignition cycles, etc.). Sent after initial registration and subsequently after any change in the calculated hash of all persisted app data.
 */
@interface SDLOnHashChange : SDLRPCNotification

/**
 Calculated hash ID to be referenced during RegisterAppInterface request.
 */
@property (strong, nonatomic) NSString *hashID;

@end

NS_ASSUME_NONNULL_END
