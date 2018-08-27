//
//  PerformInteractionManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 5/15/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "PerformInteractionManager.h"
#import "AppConstants.h"
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PerformInteractionManager

static UInt32 ChoiceSetId = 100;

+ (SDLCreateInteractionChoiceSet *)createInteractionChoiceSet {
    return [[SDLCreateInteractionChoiceSet alloc] initWithId:ChoiceSetId choiceSet:[self sdlex_createChoiceSet]];
}

+ (void)showPerformInteractionChoiceSetWithManager:(SDLManager *)manager triggerSource:(SDLTriggerSource)triggerSource {
    [manager sendRequest:[self sdlex_createPerformInteractionWithTriggerSource:triggerSource] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (response.resultCode != SDLResultSuccess) {
            SDLLogE(@"The Show Perform Interaction Choice Set request failed: %@", error.localizedDescription);
            return;
        }

        if ([response.resultCode isEqualToEnum:SDLResultTimedOut]) {
            SDLLogD(@"The perform interaction choice set menu timed out before the user could select an item");
            [manager sendRequest:[[SDLSpeak alloc] initWithTTS:TTSYouMissed]];
        } else if ([response.resultCode isEqualToEnum:SDLResultSuccess]) {
            SDLLogD(@"The user selected an item in the perform interaction choice set menu");
            [manager sendRequest:[[SDLSpeak alloc] initWithTTS:TTSGoodJob]];
        }
    }];
}

+ (NSArray<SDLChoice *> *)sdlex_createChoiceSet {
    SDLChoice *firstChoice = [[SDLChoice alloc] initWithId:1 menuName:PICSFirstChoice vrCommands:@[PICSFirstChoice]];
    SDLChoice *secondChoice = [[SDLChoice alloc] initWithId:2 menuName:PICSSecondChoice vrCommands:@[PICSSecondChoice]];
    SDLChoice *thirdChoice = [[SDLChoice alloc] initWithId:3 menuName:PICSThirdChoice vrCommands:@[PICSThirdChoice]];
    return @[firstChoice, secondChoice, thirdChoice];
}

+ (SDLPerformInteraction *)sdlex_createPerformInteractionWithTriggerSource:(SDLTriggerSource)triggerSource {
    SDLInteractionMode interactionMode = [triggerSource isEqualToEnum:SDLTriggerSourceVoiceRecognition] ? SDLInteractionModeVoiceRecognitionOnly : SDLInteractionModeManualOnly;
    SDLPerformInteraction *performInteraction = [[SDLPerformInteraction alloc] initWithInitialPrompt:PICSInitialPrompt initialText:PICSInitialText interactionChoiceSetIDList:@[@(ChoiceSetId)] helpPrompt:PICSHelpPrompt timeoutPrompt:PICSTimeoutPrompt interactionMode:interactionMode timeout:10000];
    performInteraction.interactionLayout = SDLLayoutModeListOnly;
    return performInteraction;
}

@end

NS_ASSUME_NONNULL_END
