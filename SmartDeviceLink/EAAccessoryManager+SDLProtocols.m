//
//  EAAccessoryManager+SyncProtocols.m
//

#import "EAAccessory+SDLProtocols.h"
#import "EAAccessoryManager+SDLProtocols.h"

@implementation EAAccessoryManager (SDLProtocols)

+ (EAAccessory *)findAccessoryForProtocol:(NSString *)protocol {
    for (EAAccessory *accessory in [[EAAccessoryManager sharedAccessoryManager] connectedAccessories]) {
        if ([accessory supportsProtocol:protocol]) {
            return accessory;
        }
    }

    return nil;
}

@end
