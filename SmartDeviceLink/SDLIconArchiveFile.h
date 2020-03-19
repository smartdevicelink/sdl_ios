//
//  SDLIconArchiveFile.h
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLIconArchiveFile : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSArray *lockScreenIconCaches;

@end

@interface SDLLockScreenIconCache : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *iconFilePath;
@property (nonatomic, copy) NSDate *lastModifiedDate;

- (instancetype)initWithIconUrl:(NSString *)iconUrl iconFilePath:(NSString *)iconFilePath;

@end

NS_ASSUME_NONNULL_END
