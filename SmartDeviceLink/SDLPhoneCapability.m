//
//  SDLPhoneCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLPhoneCapability.h"

#import "SDLNames.h"


@implementation SDLPhoneCapability

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithDialNumber:(BOOL)dialNumberEnabled {
    self = [self init];
    if (!self) {
        return self;
    }

    self.dialNumberEnabled = @(dialNumberEnabled);

    return self;
}

- (void)setDialNumberEnabled:(NSNumber *)dialNumberEnabled {
    if (dialNumberEnabled != nil) {
        store[NAMES_dialNumberEnabled] = dialNumberEnabled;
    } else {
        [store removeObjectForKey:NAMES_dialNumberEnabled];
    }
}

- (NSNumber *)dialNumberEnabled {
    return store[NAMES_dialNumberEnabled];
}

@end
