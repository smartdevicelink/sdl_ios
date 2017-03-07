//
//  TestLogTarget.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/7/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogTarget.h"

@interface TestLogTarget : NSObject<SDLLogTarget>

@property (strong, nonatomic, readonly) NSArray<NSString *> *loggedMessages;

@end
