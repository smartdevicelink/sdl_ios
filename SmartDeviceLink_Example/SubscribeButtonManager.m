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
        [self.sdlManager.screenManager subscribeButton:buttonName withObserver:self selector:@selector(sdlex_buttonPressEventWithButtonName:error:buttonPress:)];
    }
}

- (void)sdlex_buttonPressEventWithButtonName:(SDLButtonName)buttonName error:(NSError *)error buttonPress:(SDLOnButtonPress *)buttonPress {
    if (error != nil) {
        SDLLogE(@"There was an error subscribing to the preset button: %@",  error.localizedDescription);
        return;
    }

    NSString *alertMessage = nil;
    if ([buttonPress.buttonPressMode isEqualToEnum:SDLButtonPressModeShort]) {
        alertMessage = [NSString stringWithFormat:@"%@ short pressed", buttonName];
    } else {
        alertMessage = [NSString stringWithFormat:@"%@ long pressed", buttonName];
    }

    SDLAlert *alert = [AlertManager alertWithMessageAndCloseButton:alertMessage textField2:nil iconName:nil];
    [self.sdlManager sendRPC:alert];
}

+ (NSArray<SDLButtonName> *)sdlex_allPresetButtons {
    return @[SDLButtonNamePreset0, SDLButtonNamePreset1, SDLButtonNamePreset2, SDLButtonNamePreset3, SDLButtonNamePreset4, SDLButtonNamePreset5, SDLButtonNamePreset6, SDLButtonNamePreset7];
}

@end

NS_ASSUME_NONNULL_END
