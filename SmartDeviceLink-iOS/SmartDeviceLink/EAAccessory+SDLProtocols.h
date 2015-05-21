//
//  EAAccessory+SyncProtocols.h
//

@import ExternalAccessory;

@interface EAAccessory (SDLProtocols)

- (BOOL)supportsProtocol:(NSString *)protocol;

@end
