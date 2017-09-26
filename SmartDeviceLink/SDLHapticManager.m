//
//  SDLHapticManager.m
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLHapticManager.h"
#import "SDLNotificationConstants.h"
#import "SDLRectangle.h"
#import "SDLHapticRect.h"
#import "SDLSendHapticData.h"
#import "SDLTouch.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLHapticManager()

/**
 The projection window associated with the Haptic Manager
 */
@property (nonatomic, strong) UIWindow *projectionWindow;

/**
 Array of focusable view objects extracted from the projection window
 */
@property (nonatomic, strong) NSMutableArray<UIView *> *focusableViews;

/**
 reference to SDLConnectionManager
 */
@property (nonatomic, strong) id<SDLConnectionManagerType> connectionManager;
@end


@implementation SDLHapticManager

- (instancetype)initWithWindow:(UIWindow *)window connectionManager:(id<SDLConnectionManagerType>)connectionManager{
    self = [super init];
    if(!self) {
        return nil;
    }
    
    _projectionWindow = window;
    _connectionManager = connectionManager;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_projectionViewUpdated:) name:SDLDidProjectionViewUpdate object:nil];
    
    return self;
}

- (void)updateInterfaceLayout {
    self.focusableViews = [[NSMutableArray alloc] init];
    [self sdl_parseViewHierarchy:self.projectionWindow.subviews.lastObject];
    
    // If there is a preferred view bring that into top of the array
    NSUInteger preferredViewIndex = [self.focusableViews indexOfObject:self.projectionWindow.subviews.lastObject.preferredFocusedView];
    if (preferredViewIndex != NSNotFound && self.focusableViews.count > 1) {
        [self.focusableViews exchangeObjectAtIndex:preferredViewIndex withObjectAtIndex:0];
    }
    
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
    
    NSArray *focusableSubviews = [currentView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return evaluatedObject.canBecomeFocused;
    }]];
    
    //if current view is focusable and it doesn't have any focusable sub views then add the cuurent view and return
    if (currentView.canBecomeFocused && focusableSubviews.count == 0) {
        [self.focusableViews addObject:currentView];
        return;
    }
    // if current view has focusable sub views parse them recursively
    else if (currentView.subviews.count > 0) {
        NSArray<UIView *> *subviews = currentView.subviews;
        
        for (UIView *childView in subviews) {
            [self sdl_parseViewHierarchy:childView];
        }
    }
    //else just return
    else {
        return;
    }
}

/**
 Iterates through the focusable views, extracts rectangular parameters, creates Haptic RPC request and sends it
 */
- (void)sdl_sendHapticRPC {
    NSMutableArray<SDLHapticRect *> *hapticRects = [[NSMutableArray alloc] init];
    
    for (UIView *view in self.focusableViews) {
        CGPoint originOnScreen = [view.superview convertPoint:view.frame.origin toView:nil];
        CGRect convertedRect = {originOnScreen, view.bounds.size};
        SDLRectangle* rect = [[SDLRectangle alloc] initWithCGRect:(convertedRect)];
        // using the view index as the id field in SendHapticData request (should be guaranteed unique)
        NSUInteger rectId = [self.focusableViews indexOfObject:view];
        SDLHapticRect *hapticRect = [[SDLHapticRect alloc] initWithId:(UInt32)rectId rect:rect];
        [hapticRects addObject:hapticRect];
    }
    
    SDLSendHapticData* hapticRPC = [[SDLSendHapticData alloc] initWithHapticRectData:hapticRects];
    [self.connectionManager sendManagerRequest:hapticRPC withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
    }];
}

#pragma mark SDLHapticHitTester functions
- (nullable UIView *)viewForSDLTouch:(SDLTouch *)touch {
    UIView *selectedView = nil;
    
    for (UIView *view in self.focusableViews) {
        //Convert the absolute location to local location and check if that falls within view boundary
        CGPoint localPoint = [view convertPoint:touch.location fromView:self.projectionWindow];
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
    
    if(selectedView != nil) {
        NSUInteger selectedViewIndex = [self.focusableViews indexOfObject:selectedView];
        
        if (selectedViewIndex != NSNotFound) {
            return self.focusableViews[selectedViewIndex];
        }
    }
    return nil;
}

#pragma mark notifications
/**
 Function that gets called when projection view updated notification occurs.

 @param notification object with notification data
 */
- (void)sdl_projectionViewUpdated:(NSNotification *)notification {
    [self updateInterfaceLayout];
}

@end

NS_ASSUME_NONNULL_END
