//
//  EAAccessory+SyncProtocols.h
//
//  Copyright (c) 2014 FMC. All rights reserved.
//

#import <ExternalAccessory/ExternalAccessory.h>

@interface EAAccessory (SDLProtocols)

- (BOOL)supportsProtocol:(NSString *)protocol;

@end
