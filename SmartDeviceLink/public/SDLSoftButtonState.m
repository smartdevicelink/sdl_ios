//
//  SDLSoftButtonState.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonState.h"

#import "SDLArtwork.h"
#import "SDLImage.h"
#import "SDLLogMacros.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFile()

@property (assign, nonatomic, readwrite) BOOL persistent;

@end

@interface SDLSoftButtonState()

@property (strong, nonatomic, readonly) SDLSoftButtonType type;
@property (strong, nonatomic, readonly, nullable) SDLImage *image;

@end

@implementation SDLSoftButtonState

- (instancetype)initWithStateName:(NSString *)stateName text:(nullable NSString *)text image:(nullable UIImage *)image {
    NSParameterAssert((text != nil) || (image != nil));
    if ((text == nil) && (image == nil)) {
        SDLLogE(@"Error creating soft button state: the state requires either text or an image, or both. StateName: %@", stateName);
        return nil;
    }

    SDLArtwork *artwork = [[SDLArtwork alloc] initWithImage:image persistent:YES asImageFormat:SDLArtworkImageFormatPNG];
    return [self initWithStateName:stateName text:text artwork:artwork];
}

- (instancetype)initWithStateName:(NSString *)stateName text:(nullable NSString *)text artwork:(nullable SDLArtwork *)artwork {
    self = [super init];
    if (!self) { return nil; }

    NSParameterAssert((text != nil) || (artwork != nil));
    if ((text == nil) && (artwork == nil)) {
        SDLLogE(@"Error creating soft button state: the state requires either text or an image, or both. StateName: %@", stateName);
        return nil;
    }

    _name = stateName;
    _text = text;
    _artwork = artwork;
    _systemAction = SDLSystemActionDefaultAction;

    return self;
}

- (SDLSoftButton *)softButton {
    SDLSystemAction action = self.systemAction ?: SDLSystemActionDefaultAction;
    return [[SDLSoftButton alloc] initWithType:self.type text:self.text image:self.image highlighted:self.highlighted buttonId:0 systemAction:action handler:nil];
}

- (SDLSoftButtonType)type {
    if (self.artwork != nil && self.text != nil) {
        return SDLSoftButtonTypeBoth;
    } else if (self.artwork != nil) {
        return SDLSoftButtonTypeImage;
    } else {
        return SDLSoftButtonTypeText;
    }
}

- (nullable SDLImage *)image {
    if (self.artwork == nil) { return nil; }

    return self.artwork.imageRPC;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@, Text: %@, Image: %@", self.name, self.text, self.image.value];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"Name: %@, Text: %@, Image: %@, Soft Button: %@", self.name, self.text, self.image, self.softButton];
}

@end

NS_ASSUME_NONNULL_END
