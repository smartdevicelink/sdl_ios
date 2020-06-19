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
@property (strong, nonatomic) NSMutableDictionary<SDLButtonName, NSObject *> *presetButtonSubscriptionIDs;

@end

@implementation SubscribeButtonManager

- (instancetype)initWithManager:(SDLManager *)manager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _sdlManager = manager;
    _presetButtonSubscriptionIDs = [NSMutableDictionary dictionary];

    return self;
}

- (void)subscribeToPresetButtons {
    if (self.sdlManager.systemCapabilityManager.defaultMainWindowCapability.numCustomPresetsAvailable.intValue == 0) {
        SDLLogW(@"The module does not support preset buttons");
        return;
    }

    if (self.presetButtonSubscriptionIDs.count > 0) {
        SDLLogW(@"The app is already subscribed to preset buttons");
        return;
    }

    for (SDLButtonName buttonName in [self.class presetButtons]) {
        __weak typeof(self) weakSelf = self;
        NSObject *subscriptionID = [self.sdlManager.screenManager subscribeButton:buttonName withUpdateHandler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent, NSError * _Nullable error) {
            if (error != nil || buttonPress == nil) { return; }

            NSString *alertMessage;
            if ([buttonPress.buttonPressMode isEqualToEnum:SDLButtonPressModeShort]) {
                alertMessage = [NSString stringWithFormat:@"%@ pressed", buttonPress.buttonName];
            } else {
                alertMessage = [NSString stringWithFormat:@"%@ long pressed", buttonPress.buttonName];
            }

            SDLAlert *alert = [AlertManager alertWithMessageAndCloseButton:alertMessage textField2:nil iconName:nil];
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.sdlManager sendRPC:alert];
        }];

        self.presetButtonSubscriptionIDs[buttonName] = subscriptionID;
    }
}

- (void)unsubscribeToPresetButtons {
    if (self.presetButtonSubscriptionIDs.count == 0) {
        SDLLogW(@"The app is not subscribed to preset buttons");
        return;
    }

    for (SDLButtonName buttonName in self.presetButtonSubscriptionIDs) {
        NSObject *subscriptionId = self.presetButtonSubscriptionIDs[buttonName];
        __weak typeof(self) weakSelf = self;
        [self.sdlManager.screenManager unsubscribeButton:buttonName withObserver:subscriptionId withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                SDLLogE(@"The %@ button was not unsubscribed", buttonName);
                return;
            }

            SDLLogD(@"The %@ button was successfully unsubscribed", buttonName);
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.presetButtonSubscriptionIDs[buttonName] = nil;
        }];
    }
}

+ (NSArray<SDLButtonName> *)presetButtons {
    return @[SDLButtonNamePreset0, SDLButtonNamePreset1, SDLButtonNamePreset2, SDLButtonNamePreset3, SDLButtonNamePreset4, SDLButtonNamePreset5, SDLButtonNamePreset6, SDLButtonNamePreset7];
}

@end

NS_ASSUME_NONNULL_END
