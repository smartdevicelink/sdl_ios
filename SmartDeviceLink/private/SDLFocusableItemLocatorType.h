//
//  SDLHapticInterface.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLConnectionManagerType.h"

@class SDLManager;
@class SDLStreamingVideoScaleManager;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLFocusableItemLocatorType <NSObject>

/**
 Whether or not this will attempt to send haptic RPCs.

 @note Defaults to NO.
 */
@property (nonatomic, assign) BOOL enableHapticDataRequests;

/**
 The projection view controller associated with the Haptic Manager
 */
@property (nonatomic, strong) UIViewController *viewController;

/**
 Initializes the haptic interface. After initializing the application must call updateInterfaceLayout to process the view controller. Application must update later view changes in the view controller (or a change in the view controller itself) by sending the SDLDidUpdateProjectionView notification.

 @param viewController UIViewController to be checked for focusable views
 @param connectionManager Object of a class that implements ConnectionManagerType. This is used for RPC communication.
 @param videoScaleManager The scale manager that scales from the display screen coordinate system to the app's viewport coordinate system
 */
- (instancetype)initWithViewController:(UIViewController *)viewController connectionManager:(id<SDLConnectionManagerType>)connectionManager videoScaleManager:(SDLStreamingVideoScaleManager *)videoScaleManager;

/// Start observing updates
- (void)start;

/// Stop observing updates and clear data
- (void)stop;

/**
 updateInterfaceLayout crawls through the view hierarchy, updates and keep tracks of views to be reported through Haptic RPC. This function is automatically called when SDLDidUpdateProjectionView notification is sent by the application.
 */
- (void)updateInterfaceLayout;

@end

NS_ASSUME_NONNULL_END
