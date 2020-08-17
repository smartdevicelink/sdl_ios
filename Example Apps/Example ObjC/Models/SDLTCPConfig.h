//
//  SDLTCPConfig.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Leonid Lokhmatov on 5/19/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLTCPConfig : NSObject

+ (instancetype)configWithHost:(NSString*)host port:(UInt16)port;

@property (strong, nonatomic) NSString *ipAddress;
@property (assign, nonatomic) UInt16 port;

@end

NS_ASSUME_NONNULL_END
