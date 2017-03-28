//
//  EAAccessoryManager+SyncProtocols.m
//

#import "EAAccessory+SDLProtocols.h"
#import "EAAccessoryManager+SDLProtocols.h"

@implementation EAAccessoryManager (SDLProtocols)

+ (EAAccessory *)findAccessoryForProtocol:(NSString *)protocol {
    EAAccessoryManager *mgr = [EAAccessoryManager sharedAccessoryManager];
    @try{
        if (mgr){
            for (EAAccessory *accessory in mgr.connectedAccessories) {
                if ([accessory supportsProtocol:protocol]) {
                    return accessory;
                }
            }
        }
    }
    @catch (NSException *ex){
        return nil;
    }
    
    return nil;
}

@end
