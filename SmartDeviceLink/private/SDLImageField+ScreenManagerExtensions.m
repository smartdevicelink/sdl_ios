//
//  SDLImageField+ScreenManagerExtensions.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/20/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLImageField+ScreenManagerExtensions.h"

@implementation SDLImageField (ScreenManagerExtensions)

+ (NSArray<SDLImageFieldName> *)sdl_allImageFieldNames {
    return @[SDLImageFieldNameAppIcon, SDLImageFieldNameGraphic, SDLImageFieldNameMenuIcon, SDLImageFieldNameTurnIcon, SDLImageFieldNameAlertIcon, SDLImageFieldNameChoiceImage, SDLImageFieldNameCommandIcon, SDLImageFieldNameLocationImage, SDLImageFieldNameSoftButtonImage, SDLImageFieldNameSecondaryGraphic, SDLImageFieldNameShowConstantTBTIcon, SDLImageFieldNameChoiceSecondaryImage, SDLImageFieldNameVoiceRecognitionHelpItem, SDLImageFieldNameShowConstantTBTNextTurnIcon];
}

+ (NSArray<SDLFileType> *)sdl_allImageFileTypes {
    return @[SDLFileTypeBMP, SDLFileTypePNG, SDLFileTypeJPEG];
}

+ (NSArray<SDLImageField *> *)allImageFields {
    NSMutableArray<SDLImageField *> *tempImageFields = [NSMutableArray array];
    for (SDLImageFieldName fieldName in [self sdl_allImageFieldNames]) {
        [tempImageFields addObject:[[SDLImageField alloc] initWithName:fieldName imageTypeSupported:[self sdl_allImageFileTypes] imageResolution:nil]];
    }

    return tempImageFields;
}

@end
