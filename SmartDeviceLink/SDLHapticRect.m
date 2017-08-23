//
//  SDLHapticRect.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"
#import "SDLHapticRect.h"
#import "SDLNames.h"
#import "SDLRectangle.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHapticRect

- (instancetype)initWithId:(UInt32)id rect:(nonnull SDLRectangle *)rect {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.id = @(id);
    self.rect = rect;

    return self;
}

- (void)setId:(NSNumber<SDLInt> *)id {
    [store sdl_setObject:id forName:SDLNameId];
}

- (NSNumber<SDLInt> *)id {
    return [store sdl_objectForName:SDLNameId];
}

- (void)setRect:(SDLRectangle *)rect {
    [store sdl_setObject:rect forName:SDLNameRect];
}

- (SDLRectangle *)rect {
    return [store sdl_objectForName:SDLNameRect ofClass:SDLRectangle.class];
}

@end

NS_ASSUME_NONNULL_END
