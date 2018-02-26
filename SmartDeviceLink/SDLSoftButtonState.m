//
//  SDLSoftButtonState.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonState.h"

#import "SDLArtwork.h"

@implementation SDLSoftButtonState

- (instancetype)initWithStateName:(NSString *)stateName text:(nullable NSString *)text image:(nullable UIImage *)image {
    SDLArtwork *artwork = [[SDLArtwork alloc] initWithImage:image name:stateName persistent:NO asImageFormat:SDLArtworkImageFormatPNG];
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

@end
