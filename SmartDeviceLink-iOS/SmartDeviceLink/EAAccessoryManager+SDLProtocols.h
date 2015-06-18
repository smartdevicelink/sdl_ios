//
//  EAAccessoryManager+SyncProtocols.h
//

#import <ExternalAccessory/ExternalAccessory.h>

@interface EAAccessoryManager (SDLProtocols)

+ (EAAccessory *)findAccessoryForProtocol:(NSString *)protocol;

@end
