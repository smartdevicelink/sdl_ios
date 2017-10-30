//  SDLOnHashChange.h
//


#import "SDLRPCNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnHashChange : SDLRPCNotification

@property (strong, nonatomic) NSString *hashID;

@end

NS_ASSUME_NONNULL_END
