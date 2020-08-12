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

+ (SDLAlert *)alertWithMessageAndCloseButton:(NSString *)textField1 textField2:(nullable NSString *)textField2 iconName:(nullable NSString *)iconName {
    return [[SDLAlert alloc] initWithAlertText1:textField1 alertText2:textField2 alertText3:nil softButtons:@[[self.class sdlex_okSoftButton]] playTone:YES ttsChunks:nil duration:5000 progressIndicator:NO alertIcon:((iconName != nil) ? [[SDLImage alloc] initWithName:iconName isTemplate:YES] : nil) cancelID:0];
}

+ (SDLSubtleAlert *)subtleAlertWithMessageAndCloseButton:(NSString *)textField1 textField2:(nullable NSString *)textField2 iconName:(nullable NSString *)iconName {
    return [[SDLSubtleAlert alloc] initWithAlertText1:textField1 alertText2:textField2 alertIcon:((iconName != nil) ? [[SDLImage alloc] initWithName:iconName isTemplate:YES] : nil) ttsChunks:nil duration:nil softButtons:nil cancelID:0];
}

+ (void)sendAlertWithImage:(NSString *)imageName textField1:(NSString *)textField1 textField2:(nullable NSString *)textField2 sdlManager:(SDLManager *)sdlManager {
    [self sdlex_sendImageWithName:imageName sdlManager:sdlManager completionHandler:^(BOOL success, NSString * _Nullable artworkName) {
        SDLAlert *alert = [self.class alertWithMessageAndCloseButton:textField1 textField2:textField2 iconName:(success ? artworkName : nil)];
        [sdlManager sendRequest:alert];
    }];
}

+ (void)sendSubtleAlertWithImage:(NSString *)imageName textField1:(NSString *)textField1 textField2:(nullable NSString *)textField2 sdlManager:(SDLManager *)sdlManager {
    [self sdlex_sendImageWithName:imageName sdlManager:sdlManager completionHandler:^(BOOL success, NSString * _Nullable artworkName) {
        SDLSubtleAlert *subtleAlert = [self.class subtleAlertWithMessageAndCloseButton:textField1 textField2:textField2 iconName:(success ? artworkName : nil)];
        [sdlManager sendRequest:subtleAlert];
    }];
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
