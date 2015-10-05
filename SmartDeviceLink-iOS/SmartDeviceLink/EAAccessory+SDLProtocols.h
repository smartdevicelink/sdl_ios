//
//  EAAccessory+SyncProtocols.h
//

#import <ExternalAccessory/ExternalAccessory.h>

@interface EAAccessory (SDLProtocols)

- (BOOL)supportsProtocol:(NSString *)protocol;

@end
