//
//  SDLGetFile.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLGetFile.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetFile

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetFile]) {
    }
    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName appServiceId:(NSString *)appServiceId fileType:(nullable SDLFileType)fileType {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.fileName = fileName;
    self.appServiceId = appServiceId;
    self.fileType = fileType;

    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName appServiceId:(NSString *)appServiceId fileType:(nullable SDLFileType)fileType offset:(UInt32)offset length:(UInt32)length {
    self = [self initWithFileName:fileName appServiceId:appServiceId fileType:fileType];
    if (!self) {
        return nil;
    }

    self.offset = @(offset);
    self.length = @(length);

    return self;
}

- (void)setFileName:(NSString *)fileName {
    [parameters sdl_setObject:fileName forName:SDLNameFilename];
}

- (NSString *)fileName {
    return [parameters sdl_objectForName:SDLNameFilename];
}

- (void)setAppServiceId:(NSString *)appServiceId {
    [parameters sdl_setObject:appServiceId forName:SDLNameAppServiceId];
}

- (NSString *)appServiceId {
    return [parameters sdl_objectForName:SDLNameAppServiceId];
}

- (void)setFileType:(nullable SDLFileType)fileType {
    [parameters sdl_setObject:fileType forName:SDLNameFileType];
}

- (nullable SDLFileType)fileType {
    return [parameters sdl_objectForName:SDLNameFileType];
}

- (void)setOffset:(nullable NSNumber<SDLUInt> *)offset {
    [parameters sdl_setObject:offset forName:SDLNameOffset];
}

- (nullable NSNumber<SDLUInt> *)offset {
    return [parameters sdl_objectForName:SDLNameOffset];
}

- (void)setLength:(nullable NSNumber<SDLUInt> *)length {
    [parameters sdl_setObject:length forName:SDLNameLength];
}

- (nullable NSNumber<SDLUInt> *)length {
    return [parameters sdl_objectForName:SDLNameLength];
}

@end

NS_ASSUME_NONNULL_END
