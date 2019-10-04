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
#import "SDLStreamingVideoLifecycleManager.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLTouch.h"
#import "SDLCarWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFocusableItemLocator()

/**
 Array of focusable view objects extracted from the projection window
 */
@property (nonatomic, strong) NSMutableArray<UIView *> *focusableViews;
@property (nonatomic, weak) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic, nullable) SDLStreamingVideoLifecycleManager *streamManager;

@end

@implementation SDLFocusableItemLocator

- (instancetype)initWithViewController:(UIViewController *)viewController connectionManager:(id<SDLConnectionManagerType>)connectionManager streamManager:(SDLStreamingVideoLifecycleManager *)streamManager {
    self = [super init];
    if(!self) {
        return nil;
    }

    _viewController = streamManager.carWindow.rootViewController;
    _connectionManager = connectionManager;
    _streamManager = streamManager;

    _enableHapticDataRequests = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_projectionViewUpdated:) name:SDLDidUpdateProjectionView object:nil];

    return self;
}

- (void)updateInterfaceLayout {
    self.viewController.view.frame = self.streamManager.videoScaleManager.appViewportFrame;

    if (@available(iOS 9.0, *)) {
        self.focusableViews = [[NSMutableArray alloc] init];
        [self sdl_parseViewHierarchy:self.viewController.view];

        // If there is a preferred view bring that into top of the array
        NSUInteger preferredViewIndex = [self.focusableViews indexOfObject:self.viewController.view.subviews.lastObject.preferredFocusedView];
        if (preferredViewIndex != NSNotFound && self.focusableViews.count > 1) {
            [self.focusableViews exchangeObjectAtIndex:preferredViewIndex withObjectAtIndex:0];
        }

        [self sdl_sendHapticRPC];
    }
}

/**
 Crawls through the views recursively and adds focusable view into the member array

 @param currentView is the view hierarchy to be processed
 */
- (void)sdl_parseViewHierarchy:(UIView *)currentView {
    if (currentView == nil) {
        SDLLogW(@"Error: Cannot parse nil view");
        return;
    }

    // Force the view to update autolayout constraints. Otherwise the view's frame will not be correct if the root view controller's frame was resized.
    [currentView layoutSubviews];

    if (@available(iOS 9.0, *)) {
        NSArray *focusableSubviews = [currentView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return (evaluatedObject.canBecomeFocused || [evaluatedObject isKindOfClass:[UIButton class]]);
        }]];

        BOOL isButton = [currentView isKindOfClass:[UIButton class]];
        if ((currentView.canBecomeFocused || isButton) && focusableSubviews.count == 0) {
            //if current view is focusable and it doesn't have any focusable sub views then add the current view and return
            [self.focusableViews addObject:currentView];
            return;
        } else if (currentView.subviews.count > 0) {
            // if current view has focusable sub views parse them recursively
            NSArray<UIView *> *subviews = currentView.subviews;

            for (UIView *childView in subviews) {
                [self sdl_parseViewHierarchy:childView];
            }
        } else {
            return;
        }
    }
}

/**
 Iterates through the focusable views, extracts rectangular parameters, creates Haptic RPC request and sends it
 */
- (void)sdl_sendHapticRPC {
    if (!self.enableHapticDataRequests) {
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
        hapticRect = [self.streamManager.videoScaleManager scaleHapticRect:hapticRect];

        [hapticRects addObject:hapticRect];
    }

    SDLLogE(@"Sending haptic data: %@", hapticRects);
    SDLSendHapticData* hapticRPC = [[SDLSendHapticData alloc] initWithHapticRectData:hapticRects];
    [self.connectionManager sendConnectionManagerRequest:hapticRPC withResponseHandler:nil];
}

#pragma mark SDLFocusableItemHitTester functions
- (nullable UIView *)viewForPoint:(CGPoint)point {
    UIView *selectedView = nil;

    for (UIView *view in self.focusableViews) {
        //Convert the absolute location to local location and check if that falls within view boundary
        CGPoint localPoint = [view convertPoint:point fromView:self.viewController.view];
        if ([view pointInside:localPoint withEvent:nil]) {
            if (selectedView != nil) {
                selectedView = nil;
                break;
                //the point has been indentified in two views. We cannot identify which with confidence.
            } else {
                selectedView = view;
            }
        }
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
