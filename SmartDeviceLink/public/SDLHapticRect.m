//
//  SDLHapticRect.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"
#import "SDLHapticRect.h"
#import "SDLRPCParameterNames.h"
#import "SDLRectangle.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHapticRect

- (instancetype)initWithIdParam:(UInt32)idParam rect:(SDLRectangle *)rect {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.idParam = @(idParam);
    self.rect = rect;
    return self;
}

- (instancetype)initWithId:(UInt32)id rect:(nonnull SDLRectangle *)rect {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.id = @(id);
    self.rect = rect;

    return self;
}

- (void)setIdParam:(NSNumber<SDLUInt> *)idParam {
    [self.store sdl_setObject:idParam forName:SDLRPCParameterNameId];
}

- (NSNumber<SDLInt> *)idParam {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameId ofClass:NSNumber.class error:&error];
}

- (void)setId:(NSNumber<SDLInt> *)id {
    [self.store sdl_setObject:id forName:SDLRPCParameterNameId];
}

- (NSNumber<SDLInt> *)id {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameId ofClass:NSNumber.class error:&error];
}

- (void)setRect:(SDLRectangle *)rect {
    [self.store sdl_setObject:rect forName:SDLRPCParameterNameRect];
}

- (SDLRectangle *)rect {
    return [self.store sdl_objectForName:SDLRPCParameterNameRect ofClass:SDLRectangle.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
