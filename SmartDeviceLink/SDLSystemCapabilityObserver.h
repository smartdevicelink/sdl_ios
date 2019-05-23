//
//  SDLSystemCapabilityObserver.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLSystemCapabilityManager;

NS_ASSUME_NONNULL_BEGIN

/**
 An observer block whenever a subscription is called.

 @param systemCapabilityManager This manager. The user of the handler can then use the manager to pull the newest data.
 */
typedef void (^SDLCapabilityUpdateHandler)(SDLSystemCapabilityManager *systemCapabilityManager);

@interface SDLSystemCapabilityObserver : NSObject

@property (strong, nonatomic) id<NSObject> observer;
@property (assign, nonatomic) SEL selector;
@property (copy, nonatomic) SDLCapabilityUpdateHandler block;

- (instancetype)initWithObserver:(id<NSObject>)observer selector:(SEL)selector;
- (instancetype)initWithObserver:(id<NSObject>)observer block:(SDLCapabilityUpdateHandler)block;

@end

NS_ASSUME_NONNULL_END
