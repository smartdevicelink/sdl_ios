//
//  SimpleAppViewController.m
//  SmartDeviceLink-iOS
//
//  Created by Leonid Lokhmatov on 5/25/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import "SimpleAppViewController.h"
#import "SDLTouchManagerDelegate.h"
#import "SimpleRootView.h"
#import "TouchModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface SimpleAppViewController ()
@property (strong, nonatomic, nullable) IBOutletCollection(UIButton) NSArray *buttons;
@end


@interface SimpleAppViewController (SDLTouchManagerDelegate) <SDLTouchManagerDelegate>
@end


@implementation SimpleAppViewController

+ (SimpleAppViewController*)createViewController {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"ExampleApps" bundle:nil];
    SimpleAppViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"idSimpleAppViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    for (UIButton *button in self.buttons) {
        button.tag = 0;
    }
}

- (SimpleRootView *)rootView {
    return (SimpleRootView *)self.view;
}

- (void)updateOnTouchButton:(UIView * _Nullable)viewCandidate {
    if (!viewCandidate) {
        return;
    }
    for (UIButton *button in self.buttons) {
        if (button == viewCandidate) {
            button.tag += 1;
            [button setTitle:[NSString stringWithFormat:@"%03d", (int)button.tag] forState:UIControlStateNormal];
            break;
        }
    }
}

@end


//#Touch_Input:
@implementation SimpleAppViewController (SDLTouchManagerDelegate)

static const CGFloat MinSz = -8.0;

- (void)touchManager:(SDLTouchManager *)manager didReceiveSingleTapForView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    CGRect frame = view.frame;
    if (nil == view) {
        frame.origin = point;
        frame = CGRectInset(frame, MinSz, MinSz);
    }
    self.rootView.singleTap = [TouchModel touchPoint:point inRect:frame];
    [self updateOnTouchButton:view];
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, NSStringFromClass(view.class), self.rootView.singleTap);
}

- (void)touchManager:(SDLTouchManager *)manager didReceiveDoubleTapForView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    CGRect frame = view.frame;
    if (nil == view) {
        frame.origin = point;
        frame = CGRectInset(frame, MinSz, MinSz);
    }
    self.rootView.doubleTap = [TouchModel touchPoint:point inRect:frame];
    [self updateOnTouchButton:view];
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, NSStringFromClass(view.class), self.rootView.doubleTap);
}

// panning
- (void)touchManager:(SDLTouchManager *)manager panningDidStartInView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager didReceivePanningFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    NSLog(@"%s: %@-->%@", __PRETTY_FUNCTION__, NSStringFromCGPoint(fromPoint), NSStringFromCGPoint(toPoint));
}

- (void)touchManager:(SDLTouchManager *)manager panningDidEndInView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager panningCanceledAtPoint:(CGPoint)point {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(point));
}

// pinch
- (void)touchManager:(SDLTouchManager *)manager pinchDidStartInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager didReceivePinchAtCenterPoint:(CGPoint)point withScale:(CGFloat)scale {
    NSLog(@"%s: %@ : %2.2f", __PRETTY_FUNCTION__, NSStringFromCGPoint(point), scale);
}

- (void)touchManager:(SDLTouchManager *)manager didReceivePinchInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point withScale:(CGFloat)scale {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager pinchDidEndInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point {
    NSLog(@"%s: %@ > %@", __PRETTY_FUNCTION__, view, NSStringFromCGPoint(point));
}

- (void)touchManager:(SDLTouchManager *)manager pinchCanceledAtCenterPoint:(CGPoint)point {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(point));
}

#pragma mark - SDLStreamingMediaDelegate

- (void)videoStreamingSizeDidUpdate:(CGSize)displaySize {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, NSStringFromCGSize(displaySize));
}

- (void)videoStreamingSizeDoesNotMatch {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end

NS_ASSUME_NONNULL_END
