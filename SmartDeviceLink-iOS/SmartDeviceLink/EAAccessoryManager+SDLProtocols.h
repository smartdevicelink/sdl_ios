//
//  EAAccessoryManager+SyncProtocols.h
//
//  Copyright (c) 2014 FMC. All rights reserved.
//

#import <ExternalAccessory/ExternalAccessory.h>

@interface EAAccessoryManager (SDLProtocols)

+ (EAAccessory *)findAccessoryForProtocol:(NSString *)protocol;

@end
