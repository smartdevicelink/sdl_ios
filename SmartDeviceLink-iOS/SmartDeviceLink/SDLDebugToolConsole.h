//
//  SDLDebugToolConsole.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/12/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDLDebugToolConsole <NSObject>

@required
- (void)logInfo:(NSString *)info;

@end
