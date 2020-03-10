//
//  SDLIconArchiveFile.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLIconArchiveFile.h"

@implementation SDLIconArchiveFile

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.lockScreenIconCaches = [decoder decodeObjectOfClass:[NSMutableArray self] forKey:@"lockScreenIconCaches"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.lockScreenIconCaches forKey:@"lockScreenIconCaches"];
}

@end
