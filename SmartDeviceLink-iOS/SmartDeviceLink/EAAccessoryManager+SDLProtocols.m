//
//  EAAccessoryManager+SyncProtocols.m
//
//  Copyright (c) 2014 FMC. All rights reserved.
//

#import "EAAccessory+SDLProtocols.h"
#import "EAAccessoryManager+SDLProtocols.h"

@implementation EAAccessoryManager (SDLProtocols)

+ (EAAccessory *)findAccessoryForProtocol:(NSString *)protocol {

    for (EAAccessory* accessory in [[EAAccessoryManager sharedAccessoryManager] connectedAccessories]) {
        if ([accessory supportsProtocol:protocol]) {
            return accessory;
        }
    }

    return nil;
}

@end
