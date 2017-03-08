//
//  TestLogTarget.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/7/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogTarget.h"

@class SDLLogModel;


@interface TestLogTarget : NSObject<SDLLogTarget>

@property (strong, nonatomic, readonly) NSArray<SDLLogModel *> *loggedMessages;
@property (strong, nonatomic, readonly) NSArray<NSString *> *formattedLogMessages;

@end
