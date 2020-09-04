//
//  TestHapticRectViewController.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 9/1/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "TestHapticRectViewController.h"

@interface TestHapticRectViewController ()

@end

@implementation TestHapticRectViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (UIView *)preferredFocusedView {
    return (UIView *)self.preferredFocusEnvironments.firstObject;
}
#pragma clang diagnostic pop

/// Return the subviews sorted by their tag values in acending order
- (NSArray<id<UIFocusEnvironment>> *)preferredFocusEnvironments {
    NSArray<UIView *> *subViews = self.view.subviews;

    NSArray *preferredFocusViews;
    preferredFocusViews = [subViews sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [NSNumber numberWithLong:[(UIView*)a tag]];
        NSNumber *second = [NSNumber numberWithLong:[(UIView*)b tag]];
        return [first compare:second];
    }];

    return preferredFocusViews;
}

@end
