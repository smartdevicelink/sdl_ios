//
//  SDLHapticManager.m
//  SmartDeviceLink-iOS
//
//  Created by EBUser on 9/7/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLHapticManager.h"
#import "SDLNotificationConstants.h"
#import "SDLRectangle.h"
#import "SDLHapticRect.h"
#import "SDLSendHapticData.h"
#import "SDLTouch.h"

@interface SDLHapticManager()

/*!
 *  @abstract
 *      The projection window associated with the Haptic Manager
 */
@property (nonatomic, strong) UIWindow *projectionWindow;

/*!
 *  @abstract
 *      Array of focusable view objects extracted from the projection window
 */
@property (nonatomic, strong) NSMutableArray<UIView *> *focusableViews;

/*!
 *  @abstract
 *      reference to SDLManager
 */
@property (nonatomic, strong) SDLManager *sdlManager;
@end


@implementation SDLHapticManager

- (instancetype)initWithWindow:(UIWindow *)window sdlManager:(SDLManager *)sdlManager{
    if ((self = [super init])) {
        self.projectionWindow = window;
        self.sdlManager = sdlManager;
        //Can we remove this focusableViews new?
        self.focusableViews = [NSMutableArray new];
        [self updateInterfaceLayout];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectionViewUpdated:) name:SDLProjectionViewUpdate object:nil];
        
    }
    return self;

}

- (void)updateInterfaceLayout {
    self.focusableViews = [NSMutableArray new];
    [self parseViewHierarchy:[[self.projectionWindow subviews] lastObject]];
    
    NSUInteger preferredViewIndex = [self.focusableViews indexOfObject:[[[self.projectionWindow subviews] lastObject] preferredFocusedView]];
    if (preferredViewIndex != NSNotFound && _focusableViews.count > 1) {
        [self.focusableViews exchangeObjectAtIndex:preferredViewIndex withObjectAtIndex:0];
    }
    
    //Create and send RPC
    [self sendHapticRPC];
}

- (void)parseViewHierarchy:(UIView *)currentView {
    if (currentView == nil) {
        NSLog(@"Error: Cannot parse nil view");
        return;
    }
    
    NSArray *focusableSubviews = [currentView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return evaluatedObject.canBecomeFocused;
    }]];
    
    if (currentView.canBecomeFocused && focusableSubviews.count == 0) {
        [self.focusableViews addObject:currentView];
        return;
    } else if (currentView.subviews.count > 0) {
        NSArray *subviews = currentView.subviews;
        
        for (UIView *childView in subviews) {
            
            [self parseViewHierarchy:childView];
        }
    } else {
        return;
    }
}

- (void)sendHapticRPC {
    NSMutableArray<SDLHapticRect *> *hapticRects = [NSMutableArray new];
    
    for (UIView *view in self.focusableViews) {
        SDLRectangle *rect = [[SDLRectangle alloc] initWithCGRect:(view.bounds)];
        NSNumber* rectId = [[NSNumber alloc] initWithUnsignedInteger:([self.focusableViews indexOfObject:view])];
        SDLHapticRect *hapticRect = [[SDLHapticRect alloc] initWithId:rectId rect:rect];
        [hapticRects addObject:hapticRect];
    }
    NSLog(@"Sending haptic data:\n");

    //what if there is no focusable items?
    SDLSendHapticData* hapticRPC = [[SDLSendHapticData alloc] initWithHapticRectData:hapticRects];
    if(self.sdlManager) {
        [self.sdlManager sendRequest:hapticRPC withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError *     _Nullable error) {
            NSLog(@"SendHapticData:\n"
              "Request: %@"
              "Response: %@"
              "Error: %@", request, response, error);
        }];
    }
}

#pragma mark SDLHapticHitTester functions

- (UIView *)viewForSDLTouch:(SDLTouch *)touch {
    
    UIView *selectedView = nil;
    
    for (UIView *view in self.focusableViews) {
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
    
    
    if(selectedView != nil)
    {
        //Why do we need to convert object to index and index to object again?
        NSUInteger selectedViewIndex = [self.focusableViews indexOfObject:selectedView];
        
        if (selectedViewIndex != NSNotFound) {
            return [self.focusableViews objectAtIndex:selectedViewIndex];
        } else {
            return nil;
        }
    }
    
    return nil;
    
}

#pragma mark notifications
- (void)projectionViewUpdated:(NSNotification *)notification {
    [self updateInterfaceLayout];
}

@end
