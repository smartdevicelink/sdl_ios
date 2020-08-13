//
//  AlertManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "AppConstants.h"
#import "AlertManager.h"
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AlertManager

+ (SDLSoftButton *)sdlex_okSoftButton {
    return [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:AlertOKButtonText image:nil highlighted:YES buttonId:1 systemAction:nil handler:nil];
}

+ (void)sendAlertWithManager:(SDLManager *)sdlManager image:(nullable NSString *)imageName textField1:(NSString *)textField1 textField2:(nullable NSString *)textField2 {
    SDLAlert *alert = [[SDLAlert alloc] initWithAlertText1:textField1 alertText2:textField2 alertText3:nil softButtons:@[[self.class sdlex_okSoftButton]] playTone:YES ttsChunks:nil duration:5000 progressIndicator:NO alertIcon:nil cancelID:0];

    if (imageName == nil) {
        [sdlManager sendRequest:alert];
    } else {
        [self sdlex_sendImageWithName:imageName sdlManager:sdlManager completionHandler:^(BOOL success, NSString * _Nullable artworkName) {
            if (success) {
                alert.alertIcon = [[SDLImage alloc] initWithName:artworkName isTemplate:YES];
            }
            [sdlManager sendRequest:alert];
        }];
    }
}

+ (void)sendSubtleAlertWithManager:(SDLManager *)sdlManager image:(nullable NSString *)imageName textField1:(NSString *)textField1 textField2:(nullable NSString *)textField2 {
    SDLSubtleAlert *subtleAlert = [[SDLSubtleAlert alloc] initWithAlertText1:textField1 alertText2:textField2 alertIcon:nil ttsChunks:nil duration:nil softButtons:nil cancelID:0];

    if (imageName == nil) {
        [sdlManager sendRequest:subtleAlert];
    } else {
        [self sdlex_sendImageWithName:imageName sdlManager:sdlManager completionHandler:^(BOOL success, NSString * _Nullable artworkName) {
            if (success) {
                subtleAlert.alertIcon = [[SDLImage alloc] initWithName:artworkName isTemplate:YES];
            }
            [sdlManager sendRequest:subtleAlert];
        }];
    }
}

/// Helper method for uploading an image before it is shown in an alert
/// @param imageName The name of the image to upload
/// @param sdlManager The SDLManager
/// @param completionHandler Handler called when the artwork has finished uploading with the success of the upload and the name of the uploaded image.
+ (void)sdlex_sendImageWithName:(NSString *)imageName sdlManager:(SDLManager *)sdlManager completionHandler:(void (^)(BOOL success, NSString * _Nonnull artworkName))completionHandler {
    SDLArtwork *artwork = [SDLArtwork artworkWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG];

    [sdlManager.fileManager uploadArtwork:artwork completionHandler:^(BOOL success, NSString * _Nonnull artworkName, NSUInteger bytesAvailable, NSError * _Nullable error) {
        return completionHandler(success, artworkName);
    }];
}

@end

NS_ASSUME_NONNULL_END
