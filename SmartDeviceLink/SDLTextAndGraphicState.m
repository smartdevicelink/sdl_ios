//
//  SDLTextAndGraphicState.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/13/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLTextAndGraphicState.h"

@implementation SDLTextAndGraphicState

- (instancetype)initWithTextField1:(NSString *)textField1 textField2:(NSString *)textField2 textField3:(NSString *)textField3 textField4:(NSString *)textField4 mediaText:(NSString *)mediaTrackTextField title:(NSString *)title primaryGraphic:(SDLArtwork *)primaryGraphic secondaryGraphic:(SDLArtwork *)secondaryGraphic alignment:(SDLTextAlignment)alignment textField1Type:(SDLMetadataType)textField1Type textField2Type:(SDLMetadataType)textField2Type textField3Type:(SDLMetadataType)textField3Type textField4Type:(SDLMetadataType)textField4Type {
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

    return self;
}

@end
