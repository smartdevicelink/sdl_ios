//
//  SDLGetFileResponse.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLGetFileResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetFileResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetFile]) {
    }
    return self;
}

- (instancetype)initWithOffset:(UInt32)offset length:(UInt32)length fileType:(nullable SDLFileType)fileType crc:(UInt32)crc {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.offset = @(offset);
    self.length = @(length);
    self.fileType = fileType;
    self.crc = @(crc);

    return self;
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

- (void)setFileType:(nullable SDLFileType)fileType {
    [parameters sdl_setObject:fileType forName:SDLNameFileType];
}

- (nullable SDLFileType)fileType {
    return [parameters sdl_objectForName:SDLNameFileType];
}

- (void)setCrc:(nullable NSNumber<SDLUInt> *)crc {
    [parameters sdl_setObject:crc forName:SDLNameCRC];
}

- (nullable NSNumber<SDLUInt> *)crc {
    return [parameters sdl_objectForName:SDLNameCRC];
}

@end

NS_ASSUME_NONNULL_END
