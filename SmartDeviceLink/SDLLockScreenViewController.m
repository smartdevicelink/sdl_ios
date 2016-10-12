//
//  SDLLockScreenViewController.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenViewController.h"

#import "NSBundle+SDLBundle.h"
#import "SDLGlobals.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *primaryAppIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *primaryVehicleIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sdlIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backupImageView;

@property (weak, nonatomic) IBOutlet UILabel *lockedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowUpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowDownImageView;

@end


@implementation SDLLockScreenViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self sdl_layoutViews];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    BOOL useWhiteIcon = [self.class shouldUseWhiteForegroundForBackgroundColor:self.backgroundColor];

    return useWhiteIcon ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}


#pragma mark - Setters

- (void)setAppIcon:(UIImage *_Nullable)appIcon {
    _appIcon = appIcon;

    [self sdl_layoutViews];
}

- (void)setVehicleIcon:(UIImage *_Nullable)vehicleIcon {
    _vehicleIcon = vehicleIcon;

    [self sdl_layoutViews];
}

- (void)setBackgroundColor:(UIColor *_Nullable)backgroundColor {
    _backgroundColor = backgroundColor;

    self.view.backgroundColor = _backgroundColor;
    [self sdl_layoutViews];
}


#pragma mark - Layout

- (void)sdl_layoutViews {
    BOOL useWhiteIcon = [self.class shouldUseWhiteForegroundForBackgroundColor:self.backgroundColor];

    UIImage *sdlLogo = [self.class sdl_logoImageWithColor:useWhiteIcon];
    self.sdlIconImageView.image = sdlLogo;

    self.arrowUpImageView.image = [self.class sdl_arrowUpImageWithColor:useWhiteIcon];
    self.arrowDownImageView.image = [self.class sdl_arrowDownImageWithColor:useWhiteIcon];

    self.lockedLabel.textColor = useWhiteIcon ? [UIColor whiteColor] : [UIColor blackColor];

    if (self.vehicleIcon != nil && self.appIcon != nil) {
        [self sdl_setVehicleAndAppIconsLayout];
    } else if (self.vehicleIcon != nil) {
        [self sdl_setVehicleIconOnlyLayout];
    } else if (self.appIcon != nil) {
        [self sdl_setAppIconOnlyLayout];
    } else {
        [self sdl_setNoIconsLayout];
    }

    // HAX: The autolayout doesn't scale for 4s, so hide a view so it doesn't look like garbage.
    if (CGRectGetHeight([UIScreen mainScreen].bounds) == 480) {
        self.sdlIconImageView.hidden = YES;
    } else {
        self.sdlIconImageView.hidden = NO;
    }

    [self.view layoutIfNeeded];
}

- (void)sdl_setVehicleAndAppIconsLayout {
    self.primaryAppIconImageView.image = self.appIcon;
    self.primaryVehicleIconImageView.image = self.vehicleIcon;

    self.backupImageView.image = nil;

    self.arrowUpImageView.alpha = 1.0;
    self.arrowDownImageView.alpha = 1.0;

    self.sdlIconImageView.alpha = 1.0;
}

- (void)sdl_setAppIconOnlyLayout {
    self.primaryAppIconImageView.image = nil;
    self.primaryVehicleIconImageView.image = nil;

    self.backupImageView.image = self.appIcon;

    self.arrowUpImageView.alpha = 0.0;
    self.arrowDownImageView.alpha = 0.0;

    self.sdlIconImageView.alpha = 1.0;
}

- (void)sdl_setVehicleIconOnlyLayout {
    self.primaryAppIconImageView.image = nil;
    self.primaryVehicleIconImageView.image = nil;

    self.backupImageView.image = self.vehicleIcon;

    self.arrowUpImageView.alpha = 0.0;
    self.arrowDownImageView.alpha = 0.0;

    self.sdlIconImageView.alpha = 1.0;
}

- (void)sdl_setNoIconsLayout {
    self.primaryAppIconImageView.image = nil;
    self.primaryVehicleIconImageView.image = nil;

    self.backupImageView.image = self.sdlIconImageView.image;

    self.arrowUpImageView.alpha = 0.0;
    self.arrowDownImageView.alpha = 0.0;

    self.sdlIconImageView.alpha = 0.0;
}


#pragma mark - Private Image

// TODO: (Joel F.)[2016-08-22] When moved to iOS 7+, use `imageWithRenderingMode:`
+ (UIImage *)sdl_logoImageWithColor:(BOOL)white {
    return [self sdl_imageWithName:[NSString stringWithFormat:@"sdl_logo_%@", white ? @"white" : @"black"]];
}

+ (UIImage *)sdl_arrowUpImageWithColor:(BOOL)white {
    return [self sdl_imageWithName:[NSString stringWithFormat:@"lock_arrow_up_%@", white ? @"white" : @"black"]];
}

+ (UIImage *)sdl_arrowDownImageWithColor:(BOOL)white {
    return [self sdl_imageWithName:[NSString stringWithFormat:@"lock_arrow_down_%@", white ? @"white" : @"black"]];
}

+ (UIImage *)sdl_imageWithName:(NSString *)name {
    if (SDL_SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        NSString *bundlePath = [[NSBundle sdlBundle] bundlePath];
        NSInteger deviceScale = [[UIScreen mainScreen] scale];
        // We assume we are only dealing with PNGs.
        NSString *fileName = [NSString stringWithFormat:@"%@%li.png", name, (long)deviceScale];
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", bundlePath, fileName];
        NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
        return [UIImage imageWithData:imageData];
    } else {
        return [UIImage imageNamed:name inBundle:[NSBundle sdlBundle] compatibleWithTraitCollection:nil];
    }
}

+ (BOOL)shouldUseWhiteForegroundForBackgroundColor:(UIColor *)backgroundColor {
    CGFloat red, green, blue;

    [backgroundColor getRed:&red green:&green blue:&blue alpha:nil];

    // http://stackoverflow.com/a/3943023
    red = (red <= 0.3928) ? (red / 12.92) : pow(((red + 0.055) / 1.055), 2.4);
    green = (green <= 0.3928) ? (green / 12.92) : pow(((green + 0.055) / 1.055), 2.4);
    blue = (blue <= 0.3928) ? (blue / 12.92) : pow(((blue + 0.055) / 1.055), 2.4);
    CGFloat luminescence = 0.2126 * red + 0.7152 * green + 0.0722 * blue;

    return (luminescence <= 0.179);
}

@end

NS_ASSUME_NONNULL_END
