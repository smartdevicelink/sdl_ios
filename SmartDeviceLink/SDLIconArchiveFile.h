//
//  SDLIconArchiveFile.h
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLIconArchiveFile : NSObject <NSCoding>

@property (nonatomic) NSMutableArray *lockScreenIconCaches;

@end

NS_ASSUME_NONNULL_END
