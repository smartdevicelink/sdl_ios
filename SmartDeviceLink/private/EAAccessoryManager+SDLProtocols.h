//
//  EAAccessoryManager+SyncProtocols.h
//

#import <ExternalAccessory/ExternalAccessory.h>

NS_ASSUME_NONNULL_BEGIN

@interface EAAccessoryManager (SDLProtocols)

+ (nullable EAAccessory *)findAccessoryForProtocol:(NSString *)protocol;

@end

NS_ASSUME_NONNULL_END
