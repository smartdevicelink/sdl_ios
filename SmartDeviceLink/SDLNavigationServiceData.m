//
//  SDLNavigationServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLNavigationServiceData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLDateTime.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLNavigationServiceData

- (instancetype)initWithTimestamp:(SDLDateTime *)timestamp origin:(nullable SDLLocationDetails *)origin destination:(nullable SDLLocationDetails *)destination destinationETA:(nullable SDLDateTime *)destinationETA instructions:(nullable NSArray<SDLNavigationInstruction *> *)instructions nextInstructionETA:(nullable SDLDateTime *)nextInstructionETA nextInstructionDistance:(nullable NSNumber<SDLFloat> *)nextInstructionDistance nextInstructionDistanceScale:(NSNumber<SDLFloat> *)nextInstructionDistanceScale prompt:(nullable NSString *)prompt {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.timestamp = timestamp;
    self.origin = origin;
    self.destination = destination;
    self.destinationETA = destinationETA;
    self.instructions = instructions;
    self.nextInstructionETA = nextInstructionETA;
    self.nextInstructionDistance = nextInstructionDistance;
    self.nextInstructionDistanceScale = nextInstructionDistanceScale;
    self.prompt = prompt;

    return self;
}

- (void)setTimestamp:(SDLDateTime *)timestamp {
    [store sdl_setObject:timestamp forName:SDLNameTimeStamp];
}

- (SDLDateTime *)timestamp {
    return [store sdl_objectForName:SDLNameTimeStamp ofClass:SDLDateTime.class];
}

- (void)setOrigin:(nullable SDLLocationDetails *)origin {
    
}

@end

NS_ASSUME_NONNULL_END
