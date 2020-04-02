//
//  SDLIconArchiveFile.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLIconArchiveFile.h"

@implementation SDLIconArchiveFile

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    self.lockScreenIconCaches = [[NSArray alloc] init];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) { return nil; }
    
    self.lockScreenIconCaches = [decoder decodeObjectOfClass:[NSArray self] forKey:@"lockScreenIconCaches"];
    
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.lockScreenIconCaches forKey:@"lockScreenIconCaches"];
}

@end

@implementation SDLLockScreenIconCache

- (instancetype)initWithIconUrl:(NSString *)iconUrl iconFilePath:(NSString *)iconFilePath {
    self = [super init];
    if (!self) { return nil; }
    
    self.iconUrl = iconUrl;
    self.iconFilePath = iconFilePath;
    self.lastModifiedDate = [NSDate date];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) { return nil; }
    
    self.iconUrl = [decoder decodeObjectOfClass:[NSString self] forKey:@"iconUrl"];
    self.iconFilePath = [decoder decodeObjectOfClass:[NSString self] forKey:@"iconFilePath"];
    self.lastModifiedDate = [decoder decodeObjectOfClass:[NSDate self] forKey:@"lastModifiedDate"];
    
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [encoder encodeObject:self.iconFilePath forKey:@"iconFilePath"];
    [encoder encodeObject:self.lastModifiedDate forKey:@"lastModifiedDate"];
}

@end
