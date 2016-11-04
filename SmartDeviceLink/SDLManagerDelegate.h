//
//  SDLManagerDelegate.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 6/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLHMILevel;


NS_ASSUME_NONNULL_BEGIN

@protocol SDLManagerDelegate <NSObject>

/**
 *  Called upon a disconnection from the remote system.
 */
- (void)managerDidDisconnect;

/**
 *  Called when the HMI level state of this application changes on the remote system. This is equivalent to the application's state changes in iOS such as foreground, background, or closed.
 *
 *  @param oldLevel The previous level which has now been left.
 *  @param newLevel The current level.
 */
- (void)hmiLevel:(SDLHMILevel *)oldLevel didChangeToLevel:(SDLHMILevel *)newLevel;


@end

NS_ASSUME_NONNULL_END