//
//  SDLTextAndGraphicState.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/13/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLTextAndGraphicState.h"

#import "SDLArtwork.h"
#import "SDLTemplateConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTextAndGraphicState

- (instancetype)initWithTextField1:(nullable NSString *)textField1 textField2:(nullable NSString *)textField2 textField3:(nullable NSString *)textField3 textField4:(nullable NSString *)textField4 mediaText:(nullable NSString *)mediaTrackTextField title:(nullable NSString *)title primaryGraphic:(nullable SDLArtwork *)primaryGraphic secondaryGraphic:(nullable SDLArtwork *)secondaryGraphic alignment:(nullable SDLTextAlignment)alignment textField1Type:(nullable SDLMetadataType)textField1Type textField2Type:(nullable SDLMetadataType)textField2Type textField3Type:(nullable SDLMetadataType)textField3Type textField4Type:(nullable SDLMetadataType)textField4Type templateConfiguration:(nullable SDLTemplateConfiguration *)templateConfig {
    self = [self init];
    if (!self) { return nil; }

    _textField1 = textField1;
    _textField2 = textField2;
    _textField3 = textField3;
    _textField4 = textField4;
    _mediaTrackTextField = mediaTrackTextField;
    _title = title;
    _primaryGraphic = primaryGraphic;
    _secondaryGraphic = secondaryGraphic;
    _alignment = alignment;
    _textField1Type = textField1Type;
    _textField2Type = textField2Type;
    _textField3Type = textField3Type;
    _textField4Type = textField4Type;
    _templateConfig = templateConfig;

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Text Field 1: %@, 2: %@, 3: %@, 4: %@, media track: %@, title: %@, alignment: %@, text 1 type: %@, 2: %@, 3: %@, 4: %@, primary graphic: %@, secondary graphic: %@, template config: %@", _textField1, _textField2, _textField3, _textField4, _mediaTrackTextField, _title, _alignment, _textField1Type, _textField2Type, _textField3Type, _textField4Type, _primaryGraphic, _secondaryGraphic, _templateConfig];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[SDLTextAndGraphicState allocWithZone:zone] initWithTextField1:[_textField1 copy] textField2:[_textField2 copy] textField3:[_textField3 copy] textField4:[_textField4 copy] mediaText:[_mediaTrackTextField copy] title:[_title copy] primaryGraphic:[_primaryGraphic copy] secondaryGraphic:[_secondaryGraphic copy] alignment:[_alignment copy] textField1Type:[_textField1Type copy] textField2Type:[_textField2Type copy] textField3Type:[_textField3Type copy] textField4Type:[_textField4Type copy] templateConfiguration:[_templateConfig copy]];
}

- (BOOL)isEqualToTextAndGraphicState:(SDLTextAndGraphicState *)state {
    return [_textField1 isEqualToString:state.textField1] && [_textField2 isEqualToString:state.textField2] && [_textField3 isEqualToString:state.textField3] && [_textField4 isEqualToString:state.textField4] && [_mediaTrackTextField isEqualToString:state.mediaTrackTextField] && [_title isEqualToString:state.title] && [_primaryGraphic isEqual:state.primaryGraphic] && [_secondaryGraphic isEqual:state.secondaryGraphic] && [_alignment isEqualToString:state.alignment] && [_textField1Type isEqualToString:state.textField1Type] && [_textField2Type isEqualToString:state.textField2Type] && [_textField3Type isEqualToString:state.textField3Type] && [_textField4Type isEqualToString:state.textField4Type] && [_templateConfig isEqual:state.templateConfig];
}

- (BOOL)isEqual:(id)object {
    if (self == object) { return YES; }
    if (![object isMemberOfClass:self.class]) { return NO; }

    return [self isEqualToTextAndGraphicState:(SDLTextAndGraphicState *)object];
}

@end

NS_ASSUME_NONNULL_END
