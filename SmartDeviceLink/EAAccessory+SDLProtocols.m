//
//  EAAccessory+SyncProtocols.m
//

#import "EAAccessory+SDLProtocols.h"

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
