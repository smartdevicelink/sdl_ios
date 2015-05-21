//
//  EAAccessoryManager+SyncProtocols.h
//

@import ExternalAccessory;

@interface EAAccessoryManager (SDLProtocols)

+ (EAAccessory *)findAccessoryForProtocol:(NSString *)protocol;

@end
