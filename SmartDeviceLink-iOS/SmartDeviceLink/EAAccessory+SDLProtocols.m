//
//  EAAccessory+SyncProtocols.m
//

#import "EAAccessory+SDLProtocols.h"

@implementation EAAccessory (SDLProtocols)

- (BOOL)supportsProtocol:(NSString *)protocol {
    for (NSString *supportedProtocol in self.protocolStrings) {
        if ([supportedProtocol isEqualToString:protocol]) {
            return YES;
        }
    }

    return NO;
}

@end
