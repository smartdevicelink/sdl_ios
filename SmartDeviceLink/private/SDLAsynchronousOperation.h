//
//  SDLAsychronousOperation.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/25/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDLAsynchronousOperation : NSOperation

@property (copy, nonatomic, readonly, nullable) NSError *error;

- (void)start;
- (void)finishOperation;

@end
