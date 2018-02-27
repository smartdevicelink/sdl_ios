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
#import "SDLSoftButton.h"
#import "SDLSoftButtonType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonState()

@property (strong, nonatomic, readonly) SDLSoftButtonType type;
@property (strong, nonatomic, readonly, nullable) SDLImage *image;

@end

@implementation SDLSoftButtonState

- (instancetype)initWithStateName:(NSString *)stateName text:(nullable NSString *)text image:(nullable UIImage *)image {
    SDLArtwork *artwork = [[SDLArtwork alloc] initWithImage:image name:stateName persistent:NO asImageFormat:SDLArtworkImageFormatPNG]; // TODO: Use new artwork initializer
    return [self initWithStateName:stateName text:text artwork:artwork];
}

- (instancetype)initWithStateName:(NSString *)stateName text:(nullable NSString *)text artwork:(nullable SDLArtwork *)artwork {
    self = [super init];
    if (!self) { return nil; }

    _name = stateName;
    _text = text;
    _artwork = artwork;

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

    return [[SDLImage alloc] initWithName:self.artwork.name ofType:SDLImageTypeDynamic];
}

@end

NS_ASSUME_NONNULL_END
