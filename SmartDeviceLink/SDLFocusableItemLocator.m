//
//  SDLHapticManager.m
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

#import "SDLFocusableItemLocator.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLRectangle.h"
#import "SDLHapticRect.h"
#import "SDLSendHapticData.h"
#import "SDLTouch.h"
#import "CGGeometry+SDL.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFocusableItemLocator()

/**
 Array of focusable view objects extracted from the projection window
 */
@property (nonatomic, strong) NSMutableArray<UIView *> *focusableViews;

/**
 reference to SDLConnectionManager
 */
@property (nonatomic, weak) id<SDLConnectionManagerType> connectionManager;

@end


@implementation SDLFocusableItemLocator

@synthesize scale = _scale;

- (instancetype)initWithViewController:(UIViewController *)viewController connectionManager:(id<SDLConnectionManagerType>)connectionManager scale:(float)scale {
    self = [super init];
    if(!self) {
        return nil;
    }

    _scale = simd_clamp(scale, 1.f, 10.f);
    _viewController = viewController;
    _connectionManager = connectionManager;
    _enableHapticDataRequests = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_projectionViewUpdated:) name:SDLDidUpdateProjectionView object:nil];

    return self;
}

- (void)updateInterfaceLayout {
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
        const CGPoint originOnScreen = [self.viewController.view convertPoint:view.frame.origin toView:nil];
        const CGRect convertedRect = {originOnScreen, view.bounds.size};
        SDLRectangle* rect = [[SDLRectangle alloc] initWithCGRect:CGRectScale(convertedRect, self.scale)];
        // using the view index as the id field in SendHapticData request (should be guaranteed unique)
        //TODO: the index aka rectId is already known no need to look it up once again
        NSUInteger rectId = [self.focusableViews indexOfObject:view];
        SDLHapticRect *hapticRect = [[SDLHapticRect alloc] initWithId:(UInt32)rectId rect:rect];
        [hapticRects addObject:hapticRect];
    }

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
                return nil;
                //the point has been indentified in two views. We cannot identify which with confidence.
            }

            selectedView = view;
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

- (void)setScale:(float)scale {
    if (_scale != scale) {
        _scale = scale;
        [self updateInterfaceLayout];
    }
}

@end

NS_ASSUME_NONNULL_END
