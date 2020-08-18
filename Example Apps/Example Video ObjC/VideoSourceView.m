//
//  SimpleRootView.m
//  SmartDeviceLink-Example-ObjC
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import "VideoSourceView.h"

@interface VideoSourceView ()
@property (strong, nonatomic, nullable) IBOutlet UIView *singleTapView;
@property (strong, nonatomic, nullable) IBOutlet UIView *doubleTapView;
@end

@implementation VideoSourceView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self prepareTapView:self.singleTapView];
    [self prepareTapView:self.doubleTapView];
}

- (void)prepareTapView:(UIView*)view {
    view.layer.borderColor = self.doubleTapView.backgroundColor.CGColor;
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderWidth = 3;
    view.layer.cornerRadius = 3;
    view.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.singleTap) {
        self.singleTapView.frame = self.singleTap.rect;
    }
    if (self.doubleTap) {
        self.doubleTapView.frame = self.doubleTap.rect;
    }
}

- (void)hideSingleTapViewDelayed {
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(doHideSingleTapView) object:nil];
    [self performSelector:@selector(doHideSingleTapView) withObject:nil afterDelay:0.5];
}

- (void)doHideSingleTapView {
    self.singleTapView.hidden = YES;
}

- (void)hideDoubleTapViewDelayed {
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(doHideDoubleTapView) object:nil];
    [self performSelector:@selector(doHideDoubleTapView) withObject:nil afterDelay:0.5];
}

- (void)doHideDoubleTapView {
    self.doubleTapView.hidden = YES;
}

- (void)setSingleTap:(TouchModel *)singleTap {
    _singleTap = singleTap;
    self.singleTapView.hidden = (nil == singleTap);
    [self hideSingleTapViewDelayed];

    if (self.window) {
        [self setNeedsLayout];
    } else {
        [self layoutSubviews];
    }
}

- (void)setDoubleTap:(TouchModel *)doubleTap {
    _doubleTap = doubleTap;
    self.doubleTapView.hidden = (nil == doubleTap);
    [self hideDoubleTapViewDelayed];

    if (self.window) {
        [self setNeedsLayout];
    } else {
        [self layoutSubviews];
    }
}

@end
