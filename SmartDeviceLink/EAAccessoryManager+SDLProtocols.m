//
//  EAAccessoryManager+SyncProtocols.m
//

#import "EAAccessory+SDLProtocols.h"
#import "EAAccessoryManager+SDLProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@implementation EAAccessoryManager (SDLProtocols)

+ (nullable EAAccessory *)findAccessoryForProtocol:(NSString *)protocol {
    for (EAAccessory *accessory in [[EAAccessoryManager sharedAccessoryManager] connectedAccessories]) {
        if ([accessory supportsProtocol:protocol]) {
            return accessory;
        }
    }

    return nil;
}

@end

NS_ASSUME_NONNULL_END
