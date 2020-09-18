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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_projectionViewUpdated:) name:SDLDidUpdateProjectionView object:nil];
}

- (void)stop {
    SDLLogD(@"Stopping");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.focusableViews removeAllObjects];
}

- (void)updateInterfaceLayout {
    [self.focusableViews removeAllObjects];
    [self sdl_parseViewHierarchy:self.viewController.view];

    // If there is a preferred view, move it to the front of the array
    NSUInteger preferredViewIndex = [self.focusableViews indexOfObject:(UIView *)self.viewController.preferredFocusEnvironments.firstObject];
    if (preferredViewIndex != NSNotFound && self.focusableViews.count > 1) {
        [self.focusableViews exchangeObjectAtIndex:preferredViewIndex withObjectAtIndex:0];
    }

    SDLLogD(@"Updated VC layout, sending new haptic rects");
    SDLLogV(@"For focusable views: %@", self.focusableViews);
    [self sdl_sendHapticRPC];
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

    SDLLogD(@"Parsing UIView heirarchy");
    SDLLogV(@"UIView: %@", currentView);

    // Finding focusable subviews
    NSArray *focusableSubviews = [currentView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return (evaluatedObject.canBecomeFocused || [evaluatedObject isKindOfClass:[UIButton class]]);
    }]];
    SDLLogV(@"Found focusable subviews: %@", focusableSubviews);

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

    SDLLogD(@"Found a focusable view: %@, for point: %@", selectedView, NSStringFromCGPoint(point));
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
