//
//  SDLHapticManager.m
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLFocusableItemLocator.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLRectangle.h"
#import "SDLHapticRect.h"
#import "SDLSendHapticData.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLTouch.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFocusableItemLocator()

/**
 Array of focusable view objects extracted from the projection window
 */
@property (nonatomic, strong) NSMutableArray<UIView *> *focusableViews;
@property (nonatomic, weak) id<SDLConnectionManagerType> connectionManager;

/**
 The scale manager that scales from the display screen coordinate system to the app's viewport coordinate system
*/
@property (strong, nonatomic) SDLStreamingVideoScaleManager *videoScaleManager;
@property (assign, nonatomic) BOOL isSubscribed;

@end

@implementation SDLFocusableItemLocator

- (instancetype)initWithViewController:(UIViewController *)viewController connectionManager:(id<SDLConnectionManagerType>)connectionManager videoScaleManager:(SDLStreamingVideoScaleManager *)videoScaleManager {
    self = [super init];
    if(!self) {
        return nil;
    }

    _viewController = viewController;
    _connectionManager = connectionManager;
    _videoScaleManager = videoScaleManager;
    _focusableViews = [NSMutableArray array];

    _enableHapticDataRequests = NO;

    return self;
}

- (void)start {
    SDLLogD(@"Starting");
    if (!self.isSubscribed) {
        self.isSubscribed = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_projectionViewUpdated:) name:SDLDidUpdateProjectionView object:nil];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateInterfaceLayout];
        });
    }
}

- (void)stop {
    SDLLogD(@"Stopping");
    self.isSubscribed = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.focusableViews removeAllObjects];
}

- (void)updateInterfaceLayout {
    if (@available(iOS 9.0, *)) {
        [self.focusableViews removeAllObjects];
        [self sdl_parseViewHierarchy:self.viewController.view];

        // If there is a preferred view, move it to the front of the array
        NSUInteger preferredViewIndex = [self.focusableViews indexOfObject:self.viewController.view.subviews.lastObject.preferredFocusedView];
        if (preferredViewIndex != NSNotFound && self.focusableViews.count > 1) {
            [self.focusableViews exchangeObjectAtIndex:preferredViewIndex withObjectAtIndex:0];
        }

        SDLLogD(@"Updated VC layout, sending new haptic rects");
        SDLLogV(@"For focusable views: %@", self.focusableViews);
        [self sdl_sendHapticRPC];
    } else {
        SDLLogE(@"Attempted to update user interface layout, but it only works on iOS 9.0+");
    }
}

/**
 Crawls through the views recursively and adds focusable view into the member array

 @param currentView is the view hierarchy to be processed
 */
- (void)sdl_parseViewHierarchy:(UIView *)currentView {
    if (currentView) {
        SDLLogV(@"Parsing UIView heirarchy: %@", currentView);
        // Finding focusable subviews recursevly
        BOOL focusable = NO;
        if (@available(iOS 9.0, *)) {
            focusable = currentView.canBecomeFocused;
        }
        if (focusable || [currentView isKindOfClass:[UIControl class]]) {
            [self.focusableViews addObject:currentView];
        } else {
            for (UIView *nextView in currentView.subviews) {
                [self sdl_parseViewHierarchy:nextView];
            }
        }
    }
}

/**
 Iterates through the focusable views, extracts rectangular parameters, creates Haptic RPC request and sends it
 */
- (void)sdl_sendHapticRPC {
    if (!self.enableHapticDataRequests) {
        SDLLogV(@"Attempting to send haptic data to a head unit that does not support haptic data. Haptic data will not be sent.");
        return;
    }

    if (self.focusableViews.count == 0) {
        SDLLogV(@"No haptic data to send for this view.");
        return;
    }

    NSMutableArray<SDLHapticRect *> *hapticRects = [[NSMutableArray alloc] init];
    for (UIView *view in self.focusableViews) {
        CGPoint originOnScreen = [self.viewController.view convertPoint:view.frame.origin toView:nil];
        CGRect convertedRect = {originOnScreen, view.bounds.size};
        SDLRectangle *rect = [[SDLRectangle alloc] initWithCGRect:convertedRect];
        // using the view index as the id field in SendHapticData request (should be guaranteed unique)
        NSUInteger rectId = [self.focusableViews indexOfObject:view];
        SDLHapticRect *hapticRect = [[SDLHapticRect alloc] initWithId:(UInt32)rectId rect:rect];
        hapticRect = [self.videoScaleManager scaleHapticRect:hapticRect];

        [hapticRects addObject:hapticRect];
    }

    SDLLogV(@"Sending haptic data: %@", hapticRects);
    SDLSendHapticData *hapticRPC = [[SDLSendHapticData alloc] initWithHapticRectData:hapticRects];
    [self.connectionManager sendConnectionManagerRequest:hapticRPC withResponseHandler:nil];
}

#pragma mark SDLFocusableItemHitTester functions
- (nullable UIView *)viewForPoint:(CGPoint)point {
    UIView *selectedView = [self.viewController.view hitTest:point withEvent:nil];
    if (selectedView) {
        BOOL focusable = [selectedView isKindOfClass:[UIControl class]];
        if (!focusable) {
            if (@available(iOS 9.0, *)) {
                focusable = selectedView.canBecomeFocused;
            }
        }
        if (!focusable) {
            selectedView = nil;
        }
    }

    if (selectedView) {
        SDLLogD(@"Found a focusable view: %@:%@, at point: %@",
            NSStringFromClass(selectedView.class), NSStringFromCGRect(selectedView.frame), NSStringFromCGPoint(point));
    } else {
        SDLLogD(@"Found no focusable view at point: %@", NSStringFromCGPoint(point));
    }
    return selectedView;
}

#pragma mark notifications
/**
 Function that gets called when projection view updated notification occurs.

 @param notification object with notification data
 */
- (void)sdl_projectionViewUpdated:(NSNotification *)notification {
    if ([NSThread isMainThread]) {
        [self updateInterfaceLayout];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateInterfaceLayout];
        });
    }
}

@end

NS_ASSUME_NONNULL_END
