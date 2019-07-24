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

@interface PerformInteractionManager() <SDLChoiceSetDelegate, SDLKeyboardDelegate>

@property (weak, nonatomic) SDLManager *manager;

@property (strong, nonatomic, readonly) SDLChoiceSet *choiceSet;
@property (copy, nonatomic, readonly) NSArray<SDLChoiceCell *> *cells;
@property (copy, nonatomic, readonly) NSArray<SDLVRHelpItem *> *vrHelpList;

@end

@implementation PerformInteractionManager

- (instancetype)initWithManager:(SDLManager *)manager {
    self = [super init];
    if (!self) { return nil; }

    _manager = manager;

    return self;
}

- (void)showWithTriggerSource:(SDLTriggerSource)source {
    [self.manager.screenManager presentSearchableChoiceSet:self.choiceSet mode:[self modeForTriggerSource:source] withKeyboardDelegate:self];
}

- (SDLChoiceSet *)choiceSet {
    return [[SDLChoiceSet alloc] initWithTitle:PICSInitialPrompt delegate:self layout:SDLChoiceSetLayoutList timeout:10 initialPromptString:PICSInitialPrompt timeoutPromptString:PICSTimeoutPrompt helpPromptString:PICSHelpPrompt vrHelpList:self.vrHelpList choices:self.cells];
}

- (NSArray<SDLChoiceCell *> *)cells {
    SDLChoiceCell *firstChoice = [[SDLChoiceCell alloc] initWithText:PICSFirstChoice artwork:[SDLArtwork artworkWithStaticIcon:SDLStaticIconNameKey] voiceCommands:@[VCPICSFirstChoice]];
    SDLChoiceCell *secondChoice = [[SDLChoiceCell alloc] initWithText:PICSSecondChoice artwork:[SDLArtwork artworkWithStaticIcon:SDLStaticIconNameMicrophone] voiceCommands:@[VCPICSecondChoice]];
    SDLChoiceCell *thirdChoice = [[SDLChoiceCell alloc] initWithText:PICSThirdChoice artwork:[SDLArtwork artworkWithStaticIcon:SDLStaticIconNameKey] voiceCommands:@[VCPICSThirdChoice]];

    return @[firstChoice, secondChoice, thirdChoice];
}

- (NSArray<SDLVRHelpItem *> *)vrHelpList {
    SDLVRHelpItem *vrHelpListFirst = [[SDLVRHelpItem alloc] initWithText:VCPICSFirstChoice image:nil];
    SDLVRHelpItem *vrHelpListSecond = [[SDLVRHelpItem alloc] initWithText:VCPICSecondChoice image:nil];
    SDLVRHelpItem *vrHelpListThird = [[SDLVRHelpItem alloc] initWithText:VCPICSThirdChoice image:nil];

    return @[vrHelpListFirst, vrHelpListSecond, vrHelpListThird];
}

- (SDLInteractionMode)modeForTriggerSource:(SDLTriggerSource)source {
    return ([source isEqualToEnum:SDLTriggerSourceMenu] ? SDLInteractionModeManualOnly : SDLInteractionModeVoiceRecognitionOnly);
}

#pragma mark - SDLChoiceSetDelegate

- (void)choiceSet:(SDLChoiceSet *)choiceSet didSelectChoice:(SDLChoiceCell *)choice withSource:(SDLTriggerSource)source atRowIndex:(NSUInteger)rowIndex {
    [self.manager sendRequest:[[SDLSpeak alloc] initWithTTS:TTSGoodJob]];
}

- (void)choiceSet:(SDLChoiceSet *)choiceSet didReceiveError:(NSError *)error {
    [self.manager sendRequest:[[SDLSpeak alloc] initWithTTS:TTSYouMissed]];
}

#pragma mark - SDLKeyboardDelegate

- (void)userDidSubmitInput:(NSString *)inputText withEvent:(SDLKeyboardEvent)source {
    if ([source isEqualToEnum:SDLKeyboardEventSubmitted]) {
        [self.manager sendRequest:[[SDLSpeak alloc] initWithTTS:TTSGoodJob]];
    } else if ([source isEqualToEnum:SDLKeyboardEventVoice]) {
        // Start an audio pass thru voice session
    }
}

- (void)keyboardDidAbortWithReason:(SDLKeyboardEvent)event {
    [self.manager sendRequest:[[SDLSpeak alloc] initWithTTS:TTSYouMissed]];
}

- (void)updateAutocompleteWithInput:(NSString *)currentInputText completionHandler:(SDLKeyboardAutocompleteCompletionHandler)completionHandler {
    if ([currentInputText.lowercaseString hasPrefix:@"f"]) {
        completionHandler(PICSFirstChoice);
    } else if ([currentInputText.lowercaseString hasPrefix:@"s"]) {
        completionHandler(PICSSecondChoice);
    } else if ([currentInputText.lowercaseString hasPrefix:@"t"]) {
        completionHandler(PICSThirdChoice);
    } else {
        completionHandler(nil);
    }
}

@end

NS_ASSUME_NONNULL_END
