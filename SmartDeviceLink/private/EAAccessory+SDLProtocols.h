//
//  EAAccessory+SyncProtocols.h
//

#import <ExternalAccessory/ExternalAccessory.h>

NS_ASSUME_NONNULL_BEGIN

@interface EAAccessory (SDLProtocols)

- (BOOL)supportsProtocol:(NSString *)protocol;

@end

NS_ASSUME_NONNULL_END
