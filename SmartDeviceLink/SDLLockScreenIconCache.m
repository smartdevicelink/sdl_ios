//
//  SDLLockScreenIconCache.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenIconCache.h"

@implementation SDLLockScreenIconCache

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithIconUrl:(NSString *)iconUrl iconFilePath:(NSString *)iconFilePath lastModifiedDate:(NSDate *)lastModifiedDate {
    self = [super init];
    if (!self) { return nil; }
    
    self.iconUrl = iconUrl;
    self.iconFilePath = iconFilePath;
    self.lastModifiedDate = lastModifiedDate;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) { return nil; }
    
    self.iconUrl = [decoder decodeObjectOfClass:[NSString self] forKey:@"iconUrl"];
    self.iconFilePath = [decoder decodeObjectOfClass:[NSString self] forKey:@"iconFilePath"];
    self.lastModifiedDate = [decoder decodeObjectOfClass:[NSDate self] forKey:@"lastModifiedDate"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [encoder encodeObject:self.iconFilePath forKey:@"iconFilePath"];
    [encoder encodeObject:self.lastModifiedDate forKey:@"lastModifiedDate"];
}

@end
