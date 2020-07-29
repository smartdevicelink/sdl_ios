//
//  TestSubscribeButtonObserver.h
//  SmartDeviceLink
//
//  Created by Nicole on 6/22/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLSubscribeButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestSubscribeButtonObserver : NSObject

@property (assign, nonatomic) NSUInteger selectorCalledCount;
@property (strong, nonatomic, nullable) NSMutableArray<SDLButtonName> *buttonNamesReceived;
@property (strong, nonatomic, nullable) NSMutableArray<NSError *> *buttonErrorsReceived;
@property (strong, nonatomic, nullable) NSMutableArray<SDLOnButtonEvent *> *buttonEventsReceived;
@property (strong, nonatomic, nullable) NSMutableArray<SDLOnButtonPress *> *buttonPressesReceived;

- (void)buttonPressEvent;
- (void)buttonPressEventWithButtonName:(SDLButtonName)buttonName;
- (void)buttonPressEventWithButtonName:(SDLButtonName)buttonName error:(NSError *)error;
- (void)buttonPressEventWithButtonName:(SDLButtonName)buttonName error:(NSError *)error buttonPress:(SDLOnButtonPress *)buttonPress;
- (void)buttonPressEventWithButtonName:(SDLButtonName)buttonName error:(NSError *)error buttonPress:(SDLOnButtonPress *)buttonPress buttonEvent:(SDLOnButtonEvent *)buttonEvent;

/// An invalid selector with too many parameters
- (void)buttonPressEventWithButtonName:(SDLButtonName)buttonName error:(NSError *)error buttonPress:(SDLOnButtonPress *)buttonPress buttonEvent:(SDLOnButtonEvent *)buttonEvent extraParameter:(BOOL)extraParameter;

@end

NS_ASSUME_NONNULL_END
