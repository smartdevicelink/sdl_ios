//
//  SmartDeviceLinkTests.m
//  SmartDeviceLinkTests


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SmartDeviceLink.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

QuickSpecBegin(SDLRPCRequestFactorySpec)

describe(@"BuildAddCommand Tests", ^ {
    it(@"Should build correctly", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLAddCommand* message = [SDLRPCRequestFactory buildAddCommandWithID:@33 menuName:@"Menu" parentID:@4 position:@500
                                                       vrCommands:nil iconValue:@"No" iconType:[SDLImageType STATIC] correlationID:@94];
#pragma clang diagnostic pop
        
        expect([message menuParams].position).to(equal(@500));
        expect([message menuParams].menuName).to(equal(@"Menu"));
        expect([message menuParams].parentID).to(equal(@4));
        expect([message cmdIcon].value).to(equal(@"No"));
        expect([message cmdIcon].imageType).to(equal([SDLImageType STATIC]));
        expect(message.vrCommands).to(beNil());
        expect(message.cmdID).to(equal(@33));
        expect(message.correlationID).to(equal(@94));
    
        NSArray* aliases = @[@"Joe1", @"Joe2", @"Joe3",
                             @"--------------------------------ASLONGOFASTRINGASICANPOSSIBLYMAKEINASINGLELINE---------------------------------"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        message = [SDLRPCRequestFactory buildAddCommandWithID:@276 menuName:@"Arbitrary" vrCommands:aliases correlationID:@200];
#pragma clang diagnostic pop
        
        expect([message menuParams].position).to(beNil());
        expect([message menuParams].menuName).to(equal(@"Arbitrary"));
        expect([message menuParams].parentID).to(beNil());
        expect(message.vrCommands).to(equal(aliases));
        expect(message.cmdIcon).to(beNil());
        expect(message.cmdID).to(equal(@276));
        expect(message.correlationID).to(equal(@200));
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        message = [SDLRPCRequestFactory buildAddCommandWithID:@9001 vrCommands:@[@"   ", @"  ", @" ", @""] correlationID:@27];
#pragma clang diagnostic pop
        
        expect(message.menuParams).to(beNil());
        expect(message.vrCommands).to(equal(@[@"   ", @"  ", @" ", @""]));
        expect(message.cmdIcon).to(beNil());
        expect(message.cmdID).to(equal(@9001));
        expect(message.correlationID).to(equal(@27));
    });
});

describe(@"BuildAddSubMenu Tests", ^ {
    it(@"Should build correctly", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLAddSubMenu* message = [SDLRPCRequestFactory buildAddSubMenuWithID:@234234 menuName:@"QWERTY" position:@3 correlationID:@13];
#pragma clang diagnostic pop
    
        expect(message.menuName).to(equal(@"QWERTY"));
        expect(message.position).to(equal(@3));
        expect(message.menuID).to(equal(@234234));
        expect(message.correlationID).to(equal(@13));
    
        message = [SDLRPCRequestFactory buildAddSubMenuWithID:@444 menuName:@"Words" correlationID:@423];
    
        expect(message.menuName).to(equal(@"Words"));
        expect(message.position).to(beNil());
        expect(message.menuID).to(equal(@444));
        expect(message.correlationID).to(equal(@423));
    });
});

describe(@"BuildAlert Tests", ^ {
    context(@"With Text", ^ {
        it(@"Should build correctly", ^ {
            NSArray* softButtons = @[[[SDLSoftButton alloc] init]];
            SDLAlert* message = [SDLRPCRequestFactory buildAlertWithAlertText1:@"String1" alertText2:@"String2" alertText3:@"String3"
                                                      duration:@9999 softButtons:softButtons correlationID:@41];
            
            expect(message.alertText1).to(equal(@"String1"));
            expect(message.alertText2).to(equal(@"String2"));
            expect(message.alertText3).to(equal(@"String3"));
            expect(message.ttsChunks).to(beNil());
            expect(message.duration).to(equal(@9999));
            expect(message.playTone).to(beNil());
            expect(message.progressIndicator).to(beNil());
            expect(message.softButtons).to(equal(softButtons));
            expect(message.correlationID).to(equal(@41));
        
            message = [SDLRPCRequestFactory buildAlertWithAlertText1:@"Alarming" alertText2:@"Astonishing" alertText3:@"Attention"
                                            duration:@3000 correlationID:@11234];
        
            expect(message.alertText1).to(equal(@"Alarming"));
            expect(message.alertText2).to(equal(@"Astonishing"));
            expect(message.alertText3).to(equal(@"Attention"));
            expect(message.ttsChunks).to(beNil());
            expect(message.duration).to(equal(@3000));
            expect(message.playTone).to(beNil());
            expect(message.progressIndicator).to(beNil());
            expect(message.softButtons).to(beNil());
            expect(message.correlationID).to(equal(@11234));
            
            message = [SDLRPCRequestFactory buildAlertWithAlertText1:@"1" alertText2:@"2" duration:@4153 correlationID:@1432143];
            
            expect(message.alertText1).to(equal(@"1"));
            expect(message.alertText2).to(equal(@"2"));
            expect(message.alertText3).to(beNil());
            expect(message.ttsChunks).to(beNil());
            expect(message.duration).to(equal(@4153));
            expect(message.playTone).to(beNil());
            expect(message.progressIndicator).to(beNil());
            expect(message.softButtons).to(beNil());
            expect(message.correlationID).to(equal(@1432143));
        });
    });
    
    context(@"With TTS", ^ {
        it(@"Should build correctly", ^ {
            SDLAlert* message = [SDLRPCRequestFactory buildAlertWithTTS:@"Wat" alertText1:@"11" alertText2:@"12" alertText3:@"13"
                                                      playTone:@NO duration:@3424 correlationID:@9999999];
            
            expect(message.alertText1).to(equal(@"11"));
            expect(message.alertText2).to(equal(@"12"));
            expect(message.alertText3).to(equal(@"13"));
            expect(((SDLTTSChunk*)[message ttsChunks][0]).text).to(equal(@"Wat"));
            expect(message.duration).to(equal(@3424));
            expect(message.playTone).to(equal(@NO));
            expect(message.progressIndicator).to(beNil());
            expect(message.softButtons).to(beNil());
            expect(message.correlationID).to(equal(@9999999));
            
            message = [SDLRPCRequestFactory buildAlertWithTTS:@"Say This" alertText1:@"hgkj" alertText2:@"bgydhgfc"
                                            playTone:@YES  duration:@6546 correlationID:@65436786];
            
            expect(message.alertText1).to(equal(@"hgkj"));
            expect(message.alertText2).to(equal(@"bgydhgfc"));
            expect(message.alertText3).to(beNil());
            expect(((SDLTTSChunk*)[message ttsChunks][0]).text).to(equal(@"Say This"));
            expect(message.duration).to(equal(@6546));
            expect(message.playTone).to(equal(@YES));
            expect(message.progressIndicator).to(beNil());
            expect(message.softButtons).to(beNil());
            expect(message.correlationID).to(equal(@65436786));
            
            message = [SDLRPCRequestFactory buildAlertWithTTS:@"Surprise" playTone:@YES correlationID:@34];
            
            expect(message.alertText1).to(beNil());
            expect(message.alertText2).to(beNil());
            expect(message.alertText3).to(beNil());
            expect(((SDLTTSChunk*)[message ttsChunks][0]).text).to(equal(@"Surprise"));
            expect(message.duration).to(beNil());
            expect(message.playTone).to(equal(@YES));
            expect(message.progressIndicator).to(beNil());
            expect(message.softButtons).to(beNil());
            expect(message.correlationID).to(equal(@34));
        });
    });
    
    context(@"With TTSChunks", ^ {
        it(@"Should build correctly", ^ {
            NSArray* softButtons = @[[[SDLSoftButton alloc] init]];
            NSArray* ttsChunks = @[[[SDLTTSChunk alloc] init]];
            SDLAlert* message = [SDLRPCRequestFactory buildAlertWithTTSChunks:ttsChunks alertText1:@"Astonish" alertText2:@"Hi" alertText3:@"Alert"
                                                      playTone:@NO duration:@4145 softButtons:softButtons correlationID:@19];
            
            expect(message.alertText1).to(equal(@"Astonish"));
            expect(message.alertText2).to(equal(@"Hi"));
            expect(message.alertText3).to(equal(@"Alert"));
            expect(message.ttsChunks).to(equal(ttsChunks));
            expect(message.duration).to(equal(@4145));
            expect(message.playTone).to(equal(@NO));
            expect(message.progressIndicator).to(beNil());
            expect(message.softButtons).to(equal(softButtons));
            expect(message.correlationID).to(equal(@19));
            
            message = [SDLRPCRequestFactory buildAlertWithTTSChunks:ttsChunks playTone:@YES correlationID:@1234321];
            
            expect(message.alertText1).to(beNil());
            expect(message.alertText2).to(beNil());
            expect(message.alertText3).to(beNil());
            expect(message.ttsChunks).to(equal(ttsChunks));
            expect(message.duration).to(beNil());
            expect(message.playTone).to(equal(@YES));
            expect(message.progressIndicator).to(beNil());
            expect(message.softButtons).to(beNil());
            expect(message.correlationID).to(equal(@1234321));
        });
    });
});


describe(@"SDLAlertManeuver Tests", ^ {
    __block NSMutableArray *softButtons = nil;
    __block NSMutableArray *ttsChunks = nil;
    __block SDLAlertManeuver *message = nil;
    
    describe(@"Should build correctly", ^ {
        beforeEach(^{
            softButtons = [@[[[SDLSoftButton alloc] init]] mutableCopy];
            ttsChunks = [@[[[SDLTTSChunk alloc] init]] mutableCopy];
            message = [SDLRPCRequestFactory buildAlertManeuverwithTTSchunks:ttsChunks softButtons:softButtons correlationID:@1234];
        });
        
        it(@"Should properly set TTS Chunks", ^{
            expect(message.ttsChunks).to(equal(ttsChunks));
        });
        
        it(@"Should properly set Soft Buttons", ^{
            expect(message.softButtons).to(equal(softButtons));
        });
        
        it(@"Should properly set Correlation ID", ^{
            expect(message.correlationID).to(equal(@1234));
        });
    });
});


describe(@"BuildChangeRegistration Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLChangeRegistration* message = [SDLRPCRequestFactory buildChangeRegistrationWithLanguage:[SDLLanguage EN_GB] hmiDisplayLanguage:[SDLLanguage DE_DE] correlationID:@22336644];
        
        expect(message.language).to(equal([SDLLanguage EN_GB]));
        expect(message.hmiDisplayLanguage).to(equal([SDLLanguage DE_DE]));
        expect(message.correlationID).to(equal(@22336644));
    });
});

describe(@"BuildCreateInteractionChoiceSet Tests", ^ {
    it(@"Should build correctly", ^ {
        NSArray* choices = @[[[SDLChoice alloc] init]];
        SDLCreateInteractionChoiceSet* message = [SDLRPCRequestFactory buildCreateInteractionChoiceSetWithID:@4567654 choiceSet:choices correlationID:@0];
        
        expect(message.interactionChoiceSetID).to(equal(@4567654));
        expect(message.choiceSet).to(equal(choices));
        expect(message.correlationID).to(equal(@0));
    });
});

describe(@"BuildDeleteCommand Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLDeleteCommand* message = [SDLRPCRequestFactory buildDeleteCommandWithID:@2 correlationID:@234];
        
        expect(message.cmdID).to(equal(@2));
        expect(message.correlationID).to(equal(@234));
    });
});

describe(@"BuildDeleteFile Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLDeleteFile* message = [SDLRPCRequestFactory buildDeleteFileWithName:@"CRITICAL_FILE" correlationID:@4930];
        
        expect(message.syncFileName).to(equal(@"CRITICAL_FILE"));
        expect(message.correlationID).to(equal(@4930));
    });
});

describe(@"BuildListFiles Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLListFiles* message = [SDLRPCRequestFactory buildListFilesWithCorrelationID:@13123];
        
        expect(message.correlationID).to(equal(@13123));
    });
});

describe(@"BuildDeleteInteractionChoiceSet Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLDeleteInteractionChoiceSet* message = [SDLRPCRequestFactory buildDeleteInteractionChoiceSetWithID:@46765426 correlationID:@46765426];
        
        expect(message.interactionChoiceSetID).to(equal(@46765426));
        expect(message.correlationID).to(equal(@46765426));
    });
});

describe(@"BuildDeleteSubMenu Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLDeleteSubMenu* message = [SDLRPCRequestFactory buildDeleteSubMenuWithID:@3515 correlationID:@5153];
        
        expect(message.menuID).to(equal(@3515));
        expect(message.correlationID).to(equal(@5153));
    });
});

describe(@"BuildDialNumber", ^{
    __block SDLDialNumber *message = nil;
    __block NSString *someNumberString = nil;
    
    describe(@"when built correctly", ^{
        beforeEach(^{
            someNumberString = @"1234567890";
            message = [SDLRPCRequestFactory buildDialNumberWithNumber:someNumberString];
        });
        
        it(@"should not be nil", ^{
            expect(message).toNot(beNil());
        });
        
        it(@"should have number set properly", ^{
            expect(message.number).to(equal(someNumberString));
        });
    });
});

describe(@"BuildEndAudioPassThru Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLEndAudioPassThru* message = [SDLRPCRequestFactory buildEndAudioPassThruWithCorrelationID:@13123];
        
        expect(message.correlationID).to(equal(@13123));
    });
});

describe(@"BuildGetDTCs Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLGetDTCs* message = [SDLRPCRequestFactory buildGetDTCsWithECUName:@255 correlationID:@60806050];
        
        expect(message.ecuName).to(equal(@255));
        expect(message.dtcMask).to(beNil());
        expect(message.correlationID).to(equal(@60806050));
    });
});

describe(@"BuildGetVehicleData Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLGetVehicleData* message = [SDLRPCRequestFactory buildGetVehicleDataWithGPS:@YES speed:@NO rpm:@NO
                                                           fuelLevel:@YES fuelLevelState:@YES instantFuelConsumption:@NO
                                                           externalTemperature:@YES vin:@YES prndl:@YES
                                                           tirePressure:@NO odometer:@NO beltStatus:@NO
                                                           bodyInformation:@YES deviceStatus:@NO driverBraking:@NO
                                                           wiperStatus:@NO headLampStatus:@YES engineTorque:@YES
                                                           accPedalPosition:@NO steeringWheelAngle:@YES correlationID:@936];
        
        expect(message.gps).to(equal(@YES));
        expect(message.speed).to(equal(@NO));
        expect(message.rpm).to(equal(@NO));
        expect(message.fuelLevel).to(equal(@YES));
        expect(message.fuelLevel_State).to(equal(@YES));
        expect(message.instantFuelConsumption).to(equal(@NO));
        expect(message.externalTemperature).to(equal(@YES));
        expect(message.vin).to(equal(@YES));
        expect(message.prndl).to(equal(@YES));
        expect(message.tirePressure).to(equal(@NO));
        expect(message.odometer).to(equal(@NO));
        expect(message.beltStatus).to(equal(@NO));
        expect(message.bodyInformation).to(equal(@YES));
        expect(message.deviceStatus).to(equal(@NO));
        expect(message.driverBraking).to(equal(@NO));
        expect(message.wiperStatus).to(equal(@NO));
        expect(message.headLampStatus).to(equal(@YES));
        expect(message.engineTorque).to(equal(@YES));
        expect(message.accPedalPosition).to(equal(@NO));
        expect(message.steeringWheelAngle).to(equal(@YES));
        expect(message.eCallInfo).to(beNil());
        expect(message.airbagStatus).to(beNil());
        expect(message.emergencyEvent).to(beNil());
        expect(message.clusterModeStatus).to(beNil());
        expect(message.myKey).to(beNil());
        expect(message.correlationID).to(equal(@936));
    });
});

describe(@"BuildPerformAudioPassThru Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLPerformAudioPassThru* message = [SDLRPCRequestFactory buildPerformAudioPassThruWithInitialPrompt:@"" audioPassThruDisplayText1:@"Display1" audioPassThruDisplayText2:@"Display2"
                                                                 samplingRate:[SDLSamplingRate _44KHZ] maxDuration:@10 bitsPerSample:[SDLBitsPerSample _16_BIT] audioType:[SDLAudioType PCM]
                                                                 muteAudio:@NO correlationID:@2500];
        
        expect(((SDLTTSChunk*)[message initialPrompt][0]).text).to(beNil());
        expect(message.audioPassThruDisplayText1).to(equal(@"Display1"));
        expect(message.audioPassThruDisplayText2).to(equal(@"Display2"));
        expect(message.samplingRate).to(equal([SDLSamplingRate _44KHZ]));
        expect(message.maxDuration).to(equal(@10));
        expect(message.bitsPerSample).to(equal([SDLBitsPerSample _16_BIT]));
        expect(message.audioType).to(equal([SDLAudioType PCM]));
        expect(message.muteAudio).to(equal(@NO));
        expect(message.correlationID).to(equal(@2500));
    });
});

describe(@"BuildPerformInteraction Tests", ^ {
    context(@"With Initial Chunks", ^ {
        it(@"Should build correctly", ^ {
            NSArray* initialChunks = @[[[SDLTTSChunk alloc] init]];
            NSArray* helpChunks = @[[[SDLTTSChunk alloc] init]];
            NSArray* timeoutChunks = @[[[SDLTTSChunk alloc] init]];
            NSArray* vrHelp = @[[[SDLVRHelpItem alloc] init]];
            SDLPerformInteraction* message = [SDLRPCRequestFactory buildPerformInteractionWithInitialChunks:initialChunks initialText:@"Start" interactionChoiceSetIDList:@[@878]
                                                                   helpChunks:helpChunks timeoutChunks:timeoutChunks interactionMode:[SDLInteractionMode MANUAL_ONLY] timeout:@7500
                                                                   vrHelp:vrHelp correlationID:@272727];
            
            expect(message.initialPrompt).to(equal(initialChunks));
            expect(message.initialText).to(equal(@"Start"));
            expect(message.interactionChoiceSetIDList).to(equal(@[@878]));
            expect(message.helpPrompt).to(equal(helpChunks));
            expect(message.timeoutPrompt).to(equal(timeoutChunks));
            expect(message.interactionMode).to(equal([SDLInteractionMode MANUAL_ONLY]));
            expect(message.timeout).to(equal(@7500));
            expect(message.vrHelp).to(equal(vrHelp));
            expect(message.interactionLayout).to(beNil());
            expect(message.correlationID).to(equal(@272727));
        });
    });
    
    context(@"With Initial Prompt", ^ {
        it(@"Should build correctly", ^ {
            NSArray* vrHelp = @[[[SDLVRHelpItem alloc] init]];
            SDLPerformInteraction* message = [SDLRPCRequestFactory buildPerformInteractionWithInitialPrompt:@"Nothing" initialText:@"Still Nothing" interactionChoiceSetIDList:@[@4223, @1337]
                                                                   helpPrompt:@"A Whole Lot of Nothing" timeoutPrompt:@"Time Remaining" interactionMode:[SDLInteractionMode VR_ONLY]
                                                                   timeout:@5600 vrHelp:vrHelp correlationID:@31564];
            
            expect(((SDLTTSChunk*)[message initialPrompt][0]).text).to(equal(@"Nothing"));
            expect(message.initialText).to(equal(@"Still Nothing"));
            expect(message.interactionChoiceSetIDList).to(equal(@[@4223, @1337]));
            expect(((SDLTTSChunk*)[message helpPrompt][0]).text).to(equal(@"A Whole Lot of Nothing"));
            expect(((SDLTTSChunk*)[message timeoutPrompt][0]).text).to(equal(@"Time Remaining"));
            expect(message.interactionMode).to(equal([SDLInteractionMode VR_ONLY]));
            expect(message.timeout).to(equal(@5600));
            expect(message.vrHelp).to(equal(vrHelp));
            expect(message.interactionLayout).to(beNil());
            expect(message.correlationID).to(equal(@31564));
            
            message = [SDLRPCRequestFactory buildPerformInteractionWithInitialPrompt:@"A" initialText:@"B" interactionChoiceSetIDList:@[@1, @2, @3, @4] helpPrompt:@"C" timeoutPrompt:@"D"
                                            interactionMode:[SDLInteractionMode BOTH] timeout:@10000 correlationID:@7734];
            
            expect(((SDLTTSChunk*)[message initialPrompt][0]).text).to(equal(@"A"));
            expect(message.initialText).to(equal(@"B"));
            expect(message.interactionChoiceSetIDList).to(equal(@[@1, @2, @3, @4]));
            expect(((SDLTTSChunk*)[message helpPrompt][0]).text).to(equal(@"C"));
            expect(((SDLTTSChunk*)[message timeoutPrompt][0]).text).to(equal(@"D"));
            expect(message.interactionMode).to(equal([SDLInteractionMode BOTH]));
            expect(message.timeout).to(equal(@10000));
            expect(message.vrHelp).to(beNil());
            expect(message.interactionLayout).to(beNil());
            expect(message.correlationID).to(equal(@7734));
            
            message = [SDLRPCRequestFactory buildPerformInteractionWithInitialPrompt:@"Initializing" initialText:@"Initialized" interactionChoiceSetID:@1456 vrHelp:vrHelp correlationID:@7056704];
            
            expect(((SDLTTSChunk*)[message initialPrompt][0]).text).to(equal(@"Initializing"));
            expect(message.initialText).to(equal(@"Initialized"));
            expect(message.interactionChoiceSetIDList).to(equal(@[@1456]));
            expect(message.helpPrompt).to(beNil());
            expect(message.timeoutPrompt).to(beNil());
            //Don't know whether the reason for this failure is a bug...
            expect(message.interactionMode).to(equal([SDLInteractionMode BOTH]));
            expect(message.timeout).to(beNil());
            expect(message.vrHelp).to(equal(vrHelp));
            expect(message.interactionLayout).to(beNil());
            expect(message.correlationID).to(equal(@7056704));
            
            message = [SDLRPCRequestFactory buildPerformInteractionWithInitialPrompt:@"#$%@" initialText:@"!%%&&^$" interactionChoiceSetID:@105503 correlationID:@1454156465];
            
            expect(((SDLTTSChunk*)[message initialPrompt][0]).text).to(equal(@"#$%@"));
            expect(message.initialText).to(equal(@"!%%&&^$"));
            expect(message.interactionChoiceSetIDList).to(equal(@[@105503]));
            expect(message.helpPrompt).to(beNil());
            expect(message.timeoutPrompt).to(beNil());
            expect(message.interactionMode).to(equal([SDLInteractionMode BOTH]));
            expect(message.timeout).to(beNil());
            expect(message.vrHelp).to(beNil());
            expect(message.interactionLayout).to(beNil());
            expect(message.correlationID).to(equal(@1454156465));
        });
    });
});

describe(@"BuildPutFile Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLPutFile *message = [SDLRPCRequestFactory buildPutFileWithFileName:@"YES!?" fileType:[SDLFileType GRAPHIC_BMP]  persistentFile:@165636 correlationId:@147986];
        
        expect(message.syncFileName).to(equal(@"YES!?"));
        expect(message.fileType).to(equal([SDLFileType GRAPHIC_BMP]));
        expect(message.persistentFile).to(equal(@165636));
        expect(message.correlationID).to(equal(@147986));
    });
});

describe(@"BuildReadDID Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLReadDID* message = [SDLRPCRequestFactory buildReadDIDWithECUName:@12500 didLocation:@[@1, @5, @10, @10, @5, @1] correlationID:@6465678];
        
        expect(message.ecuName).to(equal(@12500));
        expect(message.didLocation).to(equal(@[@1, @5, @10, @10, @5, @1]));
        expect(message.correlationID).to(equal(@6465678));
    });
});

describe(@"BuildRegisterAppInterface Tests", ^ {
    it(@"Should build correctly", ^ {
        // Mock the infomation that will be pulled from the mainBundle.
        id bundleMock = OCMPartialMock([NSBundle mainBundle]);
        OCMStub([bundleMock infoDictionary]).andReturn(@{@"CFBundleShortVersionString" : @"1.2.3.4"});
        OCMStub([bundleMock bundleIdentifier]).andReturn(@"com.register.test");
        
        NSMutableArray *ttsName = [NSMutableArray arrayWithArray:@[[[SDLTTSChunk alloc] init]]];
        NSMutableArray *synonyms = [NSMutableArray arrayWithArray:@[@"Q", @"W", @"E", @"R"]];
        SDLRegisterAppInterface* message = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:@"Interface" ttsName:ttsName vrSynonyms:synonyms
                                                                 isMediaApp:@YES languageDesired:[SDLLanguage EN_US]
                                                                 hmiDisplayLanguageDesired:[SDLLanguage ES_MX] appID:@"6h43g"];
        
        expect(message.syncMsgVersion).toNot(beNil());
        expect(message.syncMsgVersion.majorVersion).to(equal(@1));
        expect(message.syncMsgVersion.minorVersion).to(equal(@0));
        
        expect(message.appInfo.appBundleID).to(equal(@"com.register.test"));
        expect(message.appInfo.appDisplayName).to(equal(@"Interface"));
        expect(message.appInfo.appVersion).to(equal(@"1.2.3.4"));
        
        expect(message.appName).to(equal(@"Interface"));
        expect(message.ttsName).to(equal(ttsName));
        expect(message.ngnMediaScreenAppName).to(equal(@"Interface"));
        expect(message.vrSynonyms).to(equal(@[@"Q", @"W", @"E", @"R"]));
        expect(message.isMediaApplication).to(equal(@YES));
        expect(message.languageDesired).to(equal([SDLLanguage EN_US]));
        expect(message.hmiDisplayLanguageDesired).to(equal([SDLLanguage ES_MX]));
        expect(message.appHMIType).to(beNil());
        expect(message.hashID).to(beNil());
        expect(message.deviceInfo).toNot(beNil());
        expect(message.appID).to(equal(@"6h43g"));
        expect(message.correlationID).to(equal(@1));
        
        message = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:@"Register App Interface" isMediaApp:@NO languageDesired:[SDLLanguage PT_BR] appID:@"36g6rsw4"];
        
        expect(message.syncMsgVersion).toNot(beNil());
        expect(message.syncMsgVersion.majorVersion).to(equal(@1));
        expect(message.syncMsgVersion.minorVersion).to(equal(@0));
        
        expect(message.appInfo.appBundleID).to(equal(@"com.register.test"));
        expect(message.appInfo.appDisplayName).to(equal(@"Register App Interface"));
        expect(message.appInfo.appVersion).to(equal(@"1.2.3.4"));
        
        expect(message.appName).to(equal(@"Register App Interface"));
        expect(message.ttsName).to(beNil());
        expect(message.ngnMediaScreenAppName).to(equal(@"Register App Interface"));
        expect(message.vrSynonyms).to(equal(@[@"Register App Interface"]));
        expect(message.isMediaApplication).to(equal(@NO));
        expect(message.languageDesired).to(equal([SDLLanguage PT_BR]));
        expect(message.hmiDisplayLanguageDesired).to(equal([SDLLanguage PT_BR]));
        expect(message.appHMIType).to(beNil());
        expect(message.hashID).to(beNil());
        expect(message.deviceInfo).toNot(beNil());
        expect(message.appID).to(equal(@"36g6rsw4"));
        expect(message.correlationID).to(equal(@1));
        
        message = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:@"..." languageDesired:[SDLLanguage CS_CZ] appID:@"56ht5j"];
        
        expect(message.syncMsgVersion).toNot(beNil());
        expect(message.syncMsgVersion.majorVersion).to(equal(@1));
        expect(message.syncMsgVersion.minorVersion).to(equal(@0));
        
        expect(message.appInfo.appBundleID).to(equal(@"com.register.test"));
        expect(message.appInfo.appDisplayName).to(equal(@"..."));
        expect(message.appInfo.appVersion).to(equal(@"1.2.3.4"));
        
        expect(message.appName).to(equal(@"..."));
        expect(message.ttsName).to(beNil());
        expect(message.ngnMediaScreenAppName).to(equal(@"..."));
        expect(message.vrSynonyms).to(equal(@[@"..."]));
        expect(message.isMediaApplication).to(equal(@NO));
        expect(message.languageDesired).to(equal([SDLLanguage CS_CZ]));
        expect(message.hmiDisplayLanguageDesired).to(equal([SDLLanguage CS_CZ]));
        expect(message.appHMIType).to(beNil());
        expect(message.hashID).to(beNil());
        expect(message.deviceInfo).toNot(beNil());
        expect(message.appID).to(equal(@"56ht5j"));
        expect(message.correlationID).to(equal(@1));
    });
});

describe(@"BuildResetGlobalProperties Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLResetGlobalProperties* message = [SDLRPCRequestFactory buildResetGlobalPropertiesWithProperties:@[[SDLGlobalProperty MENUNAME], [SDLGlobalProperty TIMEOUTPROMPT]]
                                                                  correlationID:@906842];
        
        expect(message.properties).to(equal(@[[SDLGlobalProperty MENUNAME], [SDLGlobalProperty TIMEOUTPROMPT]]));
        expect(message.correlationID).to(equal(@906842));
    });
});

describe(@"BuildSendLocation", ^{
    __block SDLSendLocation *message = nil;
    __block NSNumber *someLongitude = nil;
    __block NSNumber *someLatitude = nil;
    __block NSString *someLocation = nil;
    __block NSString *someLocationDescription = nil;
    __block NSArray *someAddressLines = nil;
    __block NSString *somePhoneNumber = nil;
    __block SDLImage *someImage = nil;
    
    describe(@"when built correctly", ^{
        beforeEach(^{
            someLongitude = @123.4567;
            someLatitude = @65.4321;
            someLocation = @"Livio";
            someLocationDescription = @"A great place to work";
            someAddressLines = @[@"3136 Hilton Rd", @"Ferndale, MI", @"48220"];
            somePhoneNumber = @"248-591-0333";
            someImage = [[SDLImage alloc] init];
            
            message = [SDLRPCRequestFactory buildSendLocationWithLongitude:someLongitude latitude:someLatitude locationName:someLocation locationDescription:someLocationDescription address:someAddressLines phoneNumber:somePhoneNumber image:someImage];
        });
        
        it(@"should not be nil", ^{
            expect(message).toNot(beNil());
        });
        
        it(@"should properly set longitude", ^{
            expect(message.longitudeDegrees).to(equal(someLongitude));
        });
        
        it(@"should properly set latitude", ^{
            expect(message.latitudeDegrees).to(equal(someLatitude));
        });
        
        it(@"should properly set location", ^{
            expect(message.locationName).to(equal(someLocation));
        });
        
        it(@"should properly set location description", ^{
            expect(message.locationDescription).to(equal(someLocationDescription));
        });
        
        it(@"should properly set address lines", ^{
            expect(message.addressLines).to(equal(someAddressLines));
        });
        
        it(@"should properly set phone number", ^{
            expect(message.phoneNumber).to(equal(somePhoneNumber));
        });
        
        it(@"should properly set image", ^{
            expect(message.locationImage).to(equal(someImage));
        });
    });
});

describe(@"BuildScrollableMessage Tests", ^ {
    it(@"Should build correctly", ^ {
        NSArray* softButtons = @[[[SDLSoftButton alloc] init]];
        SDLScrollableMessage* message = [SDLRPCRequestFactory buildScrollableMessage:@"Message Box" timeout:@37821 softButtons:softButtons correlationID:@9783356];
        
        expect(message.scrollableMessageBody).to(equal(@"Message Box"));
        expect(message.timeout).to(equal(@37821));
        expect(message.softButtons).to(equal(softButtons));
        expect(message.correlationID).to(equal(@9783356));
    });
});

describe(@"BuildSetAppIcon Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLSetAppIcon* message = [SDLRPCRequestFactory buildSetAppIconWithFileName:@"Iconic" correlationID:@465819];
        
        expect(message.syncFileName).to(equal(@"Iconic"));
        expect(message.correlationID).to(equal(@465819));
    });
});

describe(@"BuildSetDisplayLayout Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLSetDisplayLayout* message = [SDLRPCRequestFactory buildSetDisplayLayout:@"NONE" correlationID:@467926];
        
        expect(message.displayLayout).to(equal(@"NONE"));
        expect(message.correlationID).to(equal(@467926));
    });
});

describe(@"BuildSetGlobalProperties Tests", ^ {
    it(@"Should build correctly", ^ {
        NSArray* help = @[[[SDLVRHelpItem alloc] init]];
        SDLSetGlobalProperties* message = [SDLRPCRequestFactory buildSetGlobalPropertiesWithHelpText:@"Beyond Help" timeoutText:@"You took too long" vrHelpTitle:@"Voice"
                                                                vrHelp:help correlationID:@5666666];
        
        expect(((SDLTTSChunk*)[message helpPrompt][0]).text).to(equal(@"Beyond Help"));
        expect(((SDLTTSChunk*)[message timeoutPrompt][0]).text).to(equal(@"You took too long"));
        expect(message.vrHelpTitle).to(equal(@"Voice"));
        expect(message.vrHelp).to(equal(help));
        expect(message.menuTitle).to(beNil());
        expect(message.menuIcon).to(beNil());
        expect(message.keyboardProperties).to(beNil());
        expect(message.correlationID).to(equal(@5666666));
        
        message = [SDLRPCRequestFactory buildSetGlobalPropertiesWithHelpText:@"Helpful" timeoutText:@"Timed Out" correlationID:@10010100];
        
        expect(((SDLTTSChunk*)[message helpPrompt][0]).text).to(equal(@"Helpful"));
        expect(((SDLTTSChunk*)[message timeoutPrompt][0]).text).to(equal(@"Timed Out"));
        expect(message.vrHelpTitle).to(beNil());
        expect(message.vrHelp).to(beNil());
        expect(message.menuTitle).to(beNil());
        expect(message.menuIcon).to(beNil());
        expect(message.keyboardProperties).to(beNil());
        expect(message.correlationID).to(equal(@10010100));
    });
});

describe(@"BuildSetMediaClockTimer Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLSetMediaClockTimer* message = [SDLRPCRequestFactory buildSetMediaClockTimerWithHours:@15 minutes:@36 seconds:@11 updateMode:[SDLUpdateMode COUNTDOWN] correlationID:@404];
        
        expect([message startTime].hours).to(equal(@15));
        expect([message startTime].minutes).to(equal(@36));
        expect([message startTime].seconds).to(equal(@11));
        expect(message.endTime).to(beNil());
        expect(message.updateMode).to(equal([SDLUpdateMode COUNTDOWN]));
        expect(message.correlationID).to(equal(@404));
    
        message = [SDLRPCRequestFactory buildSetMediaClockTimerWithUpdateMode:[SDLUpdateMode RESUME] correlationID:@11213141];
        
        expect(message.startTime).to(beNil());
        expect(message.endTime).to(beNil());
        expect(message.updateMode).to(equal([SDLUpdateMode RESUME]));
        expect(message.correlationID).to(equal(@11213141));
    });
});

describe(@"BuildShow Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLImage* image = [[SDLImage alloc] init];
        NSArray* softButtons = @[[[SDLSoftButton alloc] init]];
        SDLShow* message = [SDLRPCRequestFactory buildShowWithMainField1:@"11" mainField2:@"22" mainField3:@"33" mainField4:@"44" statusBar:@"Bar" mediaClock:@"Time" mediaTrack:@"Crucial Line"
                                                 alignment:[SDLTextAlignment CENTERED] graphic:image softButtons:softButtons customPresets:@[@"w", @"x", @"y", @"z"] correlationID:@3432343];
        
        expect(message.mainField1).to(equal(@"11"));
        expect(message.mainField2).to(equal(@"22"));
        expect(message.mainField3).to(equal(@"33"));
        expect(message.mainField4).to(equal(@"44"));
        expect(message.statusBar).to(equal(@"Bar"));
        expect(message.mediaClock).to(equal(@"Time"));
        expect(message.mediaTrack).to(equal(@"Crucial Line"));
        expect(message.alignment).to(equal([SDLTextAlignment CENTERED]));
        expect(message.graphic).to(equal(image));
        expect(message.secondaryGraphic).to(beNil());
        expect(message.softButtons).to(equal(softButtons));
        expect(message.customPresets).to(equal(@[@"w", @"x", @"y", @"z"]));
        expect(message.correlationID).to(equal(@3432343));
        
        message = [SDLRPCRequestFactory buildShowWithMainField1:@"A" mainField2:@"S" statusBar:@"D" mediaClock:@"F" mediaTrack:@"G" alignment:[SDLTextAlignment RIGHT_ALIGNED] correlationID:@999];
        
        expect(message.mainField1).to(equal(@"A"));
        expect(message.mainField2).to(equal(@"S"));
        expect(message.mainField3).to(beNil());
        expect(message.mainField4).to(beNil());
        expect(message.statusBar).to(equal(@"D"));
        expect(message.mediaClock).to(equal(@"F"));
        expect(message.mediaTrack).to(equal(@"G"));
        expect(message.alignment).to(equal([SDLTextAlignment RIGHT_ALIGNED]));
        expect(message.graphic).to(beNil());
        expect(message.secondaryGraphic).to(beNil());
        expect(message.softButtons).to(beNil());
        expect(message.customPresets).to(beNil());
        expect(message.correlationID).to(equal(@999));
        
        message = [SDLRPCRequestFactory buildShowWithMainField1:@"Hello" mainField2:@"World" alignment:[SDLTextAlignment LEFT_ALIGNED] correlationID:@38792607];
        
        expect(message.mainField1).to(equal(@"Hello"));
        expect(message.mainField2).to(equal(@"World"));
        expect(message.mainField3).to(beNil());
        expect(message.mainField4).to(beNil());
        expect(message.statusBar).to(beNil());
        expect(message.mediaClock).to(beNil());
        expect(message.mediaTrack).to(beNil());
        expect(message.alignment).to(equal([SDLTextAlignment LEFT_ALIGNED]));
        expect(message.graphic).to(beNil());
        expect(message.secondaryGraphic).to(beNil());
        expect(message.softButtons).to(beNil());
        expect(message.customPresets).to(beNil());
        expect(message.correlationID).to(equal(@38792607));
    });
});

describe(@"SDLShowConstantTBT Tests", ^ {
    __block NSMutableArray *softButtons = nil;
    __block SDLImage *image1 = nil;
    __block SDLImage *image2 = nil;
    __block SDLShowConstantTBT *message = nil;
    
    describe(@"Should build correctly", ^ {
        beforeEach(^{
            softButtons = [@[[[SDLSoftButton alloc] init]] mutableCopy];
            image1 = [[SDLImage alloc]init];
            image2 = [[SDLImage alloc]init];
            message = [SDLRPCRequestFactory buildShowConstantTBTWithString:@"Navigation Text 1" navigationText2:@"Navigation Text 2" eta:@"ETA String" timeToDestination:@"10:31 PM" totalDistance:@"1000 Miles" turnIcon:image1 nextTurnIcon:image2 distanceToManeuver:@100.11 distanceToManeuverScale:@10.20 maneuverComplete:@23.2 softButtons:softButtons correlationID:@1234];
        });
        
        it(@"Should properly set title navigation text", ^{
            expect(message.navigationText1).to(equal(@"Navigation Text 1"));
        });
        
        it(@"Should properly set secondary navigation text", ^{
            expect(message.navigationText2).to(equal(@"Navigation Text 2"));
        });
        
        it(@"Should properly set Estimated Time Of Arrival (ETA)", ^{
            expect(message.eta).to(equal(@"ETA String"));
        });
        
        it(@"Should properly set time to distance", ^{
            expect(message.timeToDestination).to(equal(@"10:31 PM"));
        });
        
        it(@"Should properly set total distance", ^{
            expect(message.totalDistance).to(equal(@"1000 Miles"));
        });
        
        it(@"Should properly set first turn icon", ^{
            expect(message.turnIcon).to(equal(image1));
        });
        
        it(@"Should properly set second turn icon", ^{
            expect(message.nextTurnIcon).to(equal(image2));
        });
        
        it(@"Should properly set distance to maneuver", ^{
            expect(message.distanceToManeuver).to(equal(@100.11));
        });
        
        it(@"Should properly set scale for distance to maneuver", ^{
            expect(message.distanceToManeuverScale).to(equal(@10.20));
        });
        
        it(@"Should properly set maneuver complete", ^{
            expect(message.maneuverComplete).to(equal(@23.2));
        });
        
        it(@"Should properly set soft buttons", ^{
            expect(message.softButtons).to(equal(softButtons));
        });
        
        it(@"Should properly set the correlation ID", ^{
            expect(message.correlationID).to(equal(@1234));
        });
    });
});

describe(@"BuildSlider Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLSlider* message = [SDLRPCRequestFactory buildSliderDynamicFooterWithNumTicks:@3 position:@2 sliderHeader:@"HEAD" sliderFooter:@[@"FOOT1", @"FOOT2", @"FOOT3"] timeout:@32321
                                                   correlationID:@200];
        
        expect(message.numTicks).to(equal(@3));
        expect(message.position).to(equal(@2));
        expect(message.sliderHeader).to(equal(@"HEAD"));
        expect(message.sliderFooter).to(equal(@[@"FOOT1", @"FOOT2", @"FOOT3"]));
        expect(message.timeout).to(equal(@32321));
        expect(message.correlationID).to(equal(@200));
        
        message = [SDLRPCRequestFactory buildSliderStaticFooterWithNumTicks:@4 position:@2 sliderHeader:@"UP" sliderFooter:@"DOWN" timeout:@65535 correlationID:@1024];
        
        expect(message.numTicks).to(equal(@4));
        expect(message.position).to(equal(@2));
        expect(message.sliderHeader).to(equal(@"UP"));
        expect(message.sliderFooter).to(equal(@[@"DOWN", @"DOWN", @"DOWN", @"DOWN"]));
        expect(message.timeout).to(equal(@65535));
        expect(message.correlationID).to(equal(@1024));
    });
});

describe(@"BuildSpeak Tests", ^ {
    it(@"Should build correctly", ^ {
        NSArray* ttsChunks = @[[[SDLTTSChunk alloc] init]];
        SDLSpeak* message = [SDLRPCRequestFactory buildSpeakWithTTS:@"GREETINGS HUMAN" correlationID:@65];
        
        expect(((SDLTTSChunk*)[message ttsChunks][0]).text).to(equal(@"GREETINGS HUMAN"));
        expect(message.correlationID).to(equal(@65));
        
        message = [SDLRPCRequestFactory buildSpeakWithTTSChunks:ttsChunks correlationID:@56];
        
        expect(message.ttsChunks).to(equal(ttsChunks));
        expect(message.correlationID).to(equal(@56));
    });
});

describe(@"BuildSubscribeButton Tests", ^ {
    it(@"Should build correctly", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSubscribeButton* message = [SDLRPCRequestFactory buildSubscribeButtonWithName:[SDLButtonName SEARCH] correlationID:@5555555];
#pragma clang diagnostic pop
        
        expect(message.buttonName).to(equal([SDLButtonName SEARCH]));
        expect(message.correlationID).to(equal(@5555555));
    });
});

describe(@"BuildSubscribeVehicleData Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLSubscribeVehicleData* message = [SDLRPCRequestFactory buildSubscribeVehicleDataWithGPS:@YES speed:@YES rpm:@YES
                                                                 fuelLevel:@NO fuelLevelState:@NO instantFuelConsumption:@NO
                                                                 externalTemperature:@YES prndl:@YES tirePressure:@YES
                                                                 odometer:@NO beltStatus:@NO bodyInformation:@NO
                                                                 deviceStatus:@YES driverBraking:@YES wiperStatus:@YES
                                                                 headLampStatus:@NO engineTorque:@NO accPedalPosition:@NO
                                                                 steeringWheelAngle:@YES correlationID:@3692581470];
        
        expect(message.gps).to(equal(@YES));
        expect(message.speed).to(equal(@YES));
        expect(message.rpm).to(equal(@YES));
        expect(message.fuelLevel).to(equal(@NO));
        expect(message.fuelLevel_State).to(equal(@NO));
        expect(message.instantFuelConsumption).to(equal(@NO));
        expect(message.externalTemperature).to(equal(@YES));
        expect(message.prndl).to(equal(@YES));
        expect(message.tirePressure).to(equal(@YES));
        expect(message.odometer).to(equal(@NO));
        expect(message.beltStatus).to(equal(@NO));
        expect(message.bodyInformation).to(equal(@NO));
        expect(message.deviceStatus).to(equal(@YES));
        expect(message.driverBraking).to(equal(@YES));
        expect(message.wiperStatus).to(equal(@YES));
        expect(message.headLampStatus).to(equal(@NO));
        expect(message.engineTorque).to(equal(@NO));
        expect(message.accPedalPosition).to(equal(@NO));
        expect(message.steeringWheelAngle).to(equal(@YES));
        expect(message.eCallInfo).to(beNil());
        expect(message.airbagStatus).to(beNil());
        expect(message.emergencyEvent).to(beNil());
        expect(message.clusterModeStatus).to(beNil());
        expect(message.myKey).to(beNil());
        expect(message.correlationID).to(equal(@3692581470));
    });
});

describe(@"BuildUnregisterAppInterface Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLUnregisterAppInterface* message = [SDLRPCRequestFactory buildUnregisterAppInterfaceWithCorrelationID:@4200];
        
        expect(message.correlationID).to(equal(@4200));
    });
});

describe(@"BuildUnsubscribeButton Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLUnsubscribeButton* message = [SDLRPCRequestFactory buildUnsubscribeButtonWithName:[SDLButtonName OK] correlationID:@88];
        
        expect(message.buttonName).to(equal([SDLButtonName OK]));
        expect(message.correlationID).to(equal(@88));
    });
});

describe(@"BuildSubscribeVehicleData Tests", ^ {
    it(@"Should build correctly", ^ {
        SDLSubscribeVehicleData* message = [SDLRPCRequestFactory buildSubscribeVehicleDataWithGPS:@YES speed:@NO rpm:@YES
                                                                 fuelLevel:@YES fuelLevelState:@NO instantFuelConsumption:@NO
                                                                 externalTemperature:@YES prndl:@NO tirePressure:@YES
                                                                 odometer:@YES beltStatus:@NO bodyInformation:@NO
                                                                 deviceStatus:@YES driverBraking:@NO wiperStatus:@YES
                                                                 headLampStatus:@YES engineTorque:@NO accPedalPosition:@NO
                                                                 steeringWheelAngle:@YES correlationID:@1627384950];
        
        expect(message.gps).to(equal(@YES));
        expect(message.speed).to(equal(@NO));
        expect(message.rpm).to(equal(@YES));
        expect(message.fuelLevel).to(equal(@YES));
        expect(message.fuelLevel_State).to(equal(@NO));
        expect(message.instantFuelConsumption).to(equal(@NO));
        expect(message.externalTemperature).to(equal(@YES));
        expect(message.prndl).to(equal(@NO));
        expect(message.tirePressure).to(equal(@YES));
        expect(message.odometer).to(equal(@YES));
        expect(message.beltStatus).to(equal(@NO));
        expect(message.bodyInformation).to(equal(@NO));
        expect(message.deviceStatus).to(equal(@YES));
        expect(message.driverBraking).to(equal(@NO));
        expect(message.wiperStatus).to(equal(@YES));
        expect(message.headLampStatus).to(equal(@YES));
        expect(message.engineTorque).to(equal(@NO));
        expect(message.accPedalPosition).to(equal(@NO));
        expect(message.steeringWheelAngle).to(equal(@YES));
        expect(message.eCallInfo).to(beNil());
        expect(message.airbagStatus).to(beNil());
        expect(message.emergencyEvent).to(beNil());
        expect(message.clusterModeStatus).to(beNil());
        expect(message.myKey).to(beNil());
        expect(message.correlationID).to(equal(@1627384950));
    });
});

describe(@"SDLUpdateTurnList Tests", ^ {
    __block NSMutableArray<SDLSoftButton *> *softButtons = nil;
    __block NSMutableArray<SDLTurn *> *turns = nil;
    __block SDLUpdateTurnList *message = nil;
    
    __block SDLTurn *turn1 = nil;
    __block SDLTurn *turn2 = nil;
    
    describe(@"Should build correctly", ^ {
        beforeEach(^{
            softButtons = [@[[[SDLSoftButton alloc] init]] mutableCopy];
            
            turn1 = [[SDLTurn alloc] init];
            turn2 = [[SDLTurn alloc] init];
            turns = [@[turn1, turn2] mutableCopy];
            
            message = [SDLRPCRequestFactory buildUpdateTurnListWithTurnList:turns softButtons:softButtons correlationID:@1234];
        });
        
        it(@"Should properly set Turns", ^{
            expect(message.turnList).to(equal(turns));
        });
        
        it(@"Should properly set Soft Buttons", ^{
            expect(message.softButtons).to(equal(softButtons));
        });
        
        it(@"Should properly set Correlation Id", ^{
            expect(message.correlationID).to(equal(@1234));
        });
    });
});

QuickSpecEnd

#pragma clang diagnostic pop
