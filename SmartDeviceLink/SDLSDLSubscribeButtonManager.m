//
//  SDLSDLSubscribeButtonManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 5/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLSDLSubscribeButtonManager.h"

#import "SDLSystemCapabilityObserver.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSDLSubscribeButtonManager

- (nullable id<NSObject>)subscribeButton:(SDLButtonName *)buttonName withBlock:(nullable SDLSubscribeButtonUpdateHandler)block {

    return nil;
}

- (void)subscribeButton:(SDLButtonName *)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector {

}

- (void)unsubscribeButtonWithObserver:(id<NSObject>)observer withCompletionHandler:(nullable SDLSubscribeButtonUpdateCompletionHandler)block {

}

@end

NS_ASSUME_NONNULL_END
