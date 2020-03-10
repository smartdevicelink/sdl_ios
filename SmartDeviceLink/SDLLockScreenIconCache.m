//
//  SDLLockScreenIconCache.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenIconCache.h"

@implementation SDLLockScreenIconCache

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.iconUrl = [decoder decodeObjectOfClass:[NSString self] forKey:@"iconUrl"];
    self.iconFilePath = [decoder decodeObjectOfClass:[NSString self] forKey:@"iconFilePath"];
    self.lastModifiedDate = [decoder decodeObjectOfClass:[NSString self] forKey:@"lastmModifiedDate"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [encoder encodeObject:self.iconFilePath forKey:@"iconFilePath"];
    [encoder encodeObject:self.lastModifiedDate forKey:@"lastmModifiedDate"];
}

@end
