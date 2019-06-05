//
//  SDLGetFileResponse.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLGetFileResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetFileResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetFile]) {
    }
    return self;
}
#pragma clang diagnostic pop

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

- (void)setFileType:(nullable SDLFileType)fileType {
    [self.parameters sdl_setObject:fileType forName:SDLRPCParameterNameFileType];
}

- (nullable SDLFileType)fileType {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameFileType error:nil];
}

- (void)setCrc:(nullable NSNumber<SDLUInt> *)crc {
    [self.parameters sdl_setObject:crc forName:SDLRPCParameterNameCRC];
}

- (nullable NSNumber<SDLUInt> *)crc {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCRC ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
