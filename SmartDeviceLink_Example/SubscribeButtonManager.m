//
//  SubscribeButtonManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 6/19/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SubscribeButtonManager.h"

#import "AlertManager.h"
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubscribeButtonManager()

@property (strong, nonatomic) SDLManager *sdlManager;

@end

@implementation SubscribeButtonManager

- (instancetype)initWithManager:(SDLManager *)manager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _sdlManager = manager;

    return self;
}

- (void)subscribeToAllPresetButtons {
    if (self.sdlManager.systemCapabilityManager.defaultMainWindowCapability.numCustomPresetsAvailable.intValue == 0) {
        SDLLogW(@"The module does not support preset buttons");
        return;
    }

    for (SDLButtonName buttonName in [self.class sdlex_allPresetButtons]) {
        __weak typeof(self) weakSelf = self;
        [self.sdlManager.screenManager subscribeButton:buttonName withUpdateHandler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (error != nil) {
                SDLLogE(@"There was an error subscribing to the preset button: %@" error.localizedDescription);
                return;
            }

            if (buttonPress == nil) { return; }

            NSString *alertMessage;
            NSString *buttonName = buttonPress.buttonName;
            if ([buttonPress.buttonPressMode isEqualToEnum:SDLButtonPressModeShort]) {
                alertMessage = [NSString stringWithFormat:@"%@ short pressed", buttonName];
            } else {
                alertMessage = [NSString stringWithFormat:@"%@ long pressed", buttonName];
            }

            SDLAlert *alert = [AlertManager alertWithMessageAndCloseButton:alertMessage textField2:nil iconName:nil];
            [strongSelf.sdlManager sendRPC:alert];
        }];
    }
}

+ (NSArray<SDLButtonName> *)sdlex_allPresetButtons {
    return @[SDLButtonNamePreset0, SDLButtonNamePreset1, SDLButtonNamePreset2, SDLButtonNamePreset3, SDLButtonNamePreset4, SDLButtonNamePreset5, SDLButtonNamePreset6, SDLButtonNamePreset7];
}

@end

NS_ASSUME_NONNULL_END
