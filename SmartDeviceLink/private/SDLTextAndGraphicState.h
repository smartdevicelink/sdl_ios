//
//  SDLTextAndGraphicState.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/13/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLMetadataType.h"
#import "SDLTextAlignment.h"

@class SDLArtwork;
@class SDLTemplateConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface SDLTextAndGraphicState : NSObject <NSCopying>

@property (copy, nonatomic, nullable) NSString *textField1;
@property (copy, nonatomic, nullable) NSString *textField2;
@property (copy, nonatomic, nullable) NSString *textField3;
@property (copy, nonatomic, nullable) NSString *textField4;
@property (copy, nonatomic, nullable) NSString *mediaTrackTextField;
@property (copy, nonatomic, nullable) NSString *title;
@property (strong, nonatomic, nullable) SDLArtwork *primaryGraphic;
@property (strong, nonatomic, nullable) SDLArtwork *secondaryGraphic;

@property (copy, nonatomic, nullable) SDLTextAlignment alignment;
@property (copy, nonatomic, nullable) SDLMetadataType textField1Type;
@property (copy, nonatomic, nullable) SDLMetadataType textField2Type;
@property (copy, nonatomic, nullable) SDLMetadataType textField3Type;
@property (copy, nonatomic, nullable) SDLMetadataType textField4Type;

@property (copy, nonatomic, nullable) SDLTemplateConfiguration *templateConfig;

- (instancetype)initWithTextField1:(nullable NSString *)textField1 textField2:(nullable NSString *)textField2 textField3:(nullable NSString *)textField3 textField4:(nullable NSString *)textField4 mediaText:(nullable NSString *)mediaTrackTextField title:(nullable NSString *)title primaryGraphic:(nullable SDLArtwork *)primaryGraphic secondaryGraphic:(nullable SDLArtwork *)secondaryGraphic alignment:(nullable SDLTextAlignment)alignment textField1Type:(nullable SDLMetadataType)textField1Type textField2Type:(nullable SDLMetadataType)textField2Type textField3Type:(nullable SDLMetadataType)textField3Type textField4Type:(nullable SDLMetadataType)textField4Type templateConfiguration:(nullable SDLTemplateConfiguration *)templateConfig;

@end

NS_ASSUME_NONNULL_END
