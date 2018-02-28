//
//  SDLTextAndGraphicConfiguration.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLTextAndGraphicConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTextAndGraphicConfiguration

- (instancetype)init {
    return [self initWithTextField1:nil textField2:nil textField3:nil textField4:nil alignment:SDLTextAlignmentCenter];
}

- (instancetype)initWithTextField1:(nullable SDLMetadataType)field1Type textField2:(nullable SDLMetadataType)field2Type textField3:(nullable SDLMetadataType)field3Type textField4:(nullable SDLMetadataType)field4Type alignment:(nullable SDLTextAlignment)alignment {
    self = [super init];
    if (!self) {
        return nil;
    }

    _textField1Type = field1Type;
    _textField2Type = field2Type;
    _textField3Type = field3Type;
    _textField4Type = field4Type;
    _alignment = alignment;

    return self;
}

+ (instancetype)defaultConfiguration {
    return [[self alloc] init];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLTextAndGraphicConfiguration *config = [[self class] allocWithZone:zone];
    config->_textField1Type = [_textField1Type copyWithZone:zone];
    config->_textField2Type = [_textField2Type copyWithZone:zone];
    config->_textField3Type = [_textField3Type copyWithZone:zone];
    config->_textField4Type = [_textField4Type copyWithZone:zone];
    config->_alignment = [_alignment copyWithZone:zone];

    return config;
}

@end

NS_ASSUME_NONNULL_END
