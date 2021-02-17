//
//  TestSystemInfoHandler.h
//  SmartDeviceLinkTests
//
//  Created by Leonid Lokhmatov on 17.02.2021.
//  Copyright © 2021 Luxoft. All rights reserved
//

#import <Foundation/Foundation.h>
#import "SDLSystemInfoHandler.h"

@class SDLSystemInfo;

NS_ASSUME_NONNULL_BEGIN

@interface TestSystemInfoHandler : NSObject <SDLSystemInfoHandler>

@property (nonatomic, strong, nullable) SDLSystemInfo *lastSystemInfo;

@property (nonatomic, assign) BOOL boolResponse;

@end

NS_ASSUME_NONNULL_END
