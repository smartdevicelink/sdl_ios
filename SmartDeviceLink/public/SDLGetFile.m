//
//  SDLGetFile.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLGetFile.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetFile

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetFile]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithFileName:(NSString *)fileName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.fileName = fileName;

    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName appServiceId:(nullable NSString *)appServiceId fileType:(nullable SDLFileType)fileType {
    self = [self initWithFileName:fileName];
    if (!self) {
        return nil;
    }

    self.appServiceId = appServiceId;
    self.fileType = fileType;

    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName appServiceId:(nullable NSString *)appServiceId fileType:(nullable SDLFileType)fileType offset:(UInt32)offset length:(UInt32)length {
    self = [self initWithFileName:fileName appServiceId:appServiceId fileType:fileType];
    if (!self) {
        return nil;
    }

    self.offset = @(offset);
    self.length = @(length);

    return self;
}

- (void)setFileName:(NSString *)fileName {
    [self.parameters sdl_setObject:fileName forName:SDLRPCParameterNameFileName];
}

- (NSString *)fileName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFileName ofClass:NSString.class error:&error];
}

- (void)setAppServiceId:(nullable NSString *)appServiceId {
    [self.parameters sdl_setObject:appServiceId forName:SDLRPCParameterNameAppServiceId];
}

- (nullable NSString *)appServiceId {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppServiceId ofClass:NSString.class error:nil];
}

- (void)setFileType:(nullable SDLFileType)fileType {
    [self.parameters sdl_setObject:fileType forName:SDLRPCParameterNameFileType];
}

- (nullable SDLFileType)fileType {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameFileType error:nil];
}

- (void)setOffset:(nullable NSNumber<SDLUInt> *)offset {
    [self.parameters sdl_setObject:offset forName:SDLRPCParameterNameOffset];
}

- (nullable NSNumber<SDLUInt> *)offset {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameOffset ofClass:NSNumber.class error:nil];
}

- (void)setLength:(nullable NSNumber<SDLUInt> *)length {
    [self.parameters sdl_setObject:length forName:SDLRPCParameterNameLength];
}

- (nullable NSNumber<SDLUInt> *)length {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameLength ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
