//
//  SDLWindowCapabilitySpec.m
//  SmartDeviceLinkTests

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonCapabilities.h"
#import "SDLDynamicUpdateCapabilities.h"
#import "SDLImageField.h"
#import "SDLImageType.h"
#import "SDLKeyboardCapabilities.h"
#import "SDLKeyboardLayoutCapability.h"
#import "SDLKeyboardProperties.h"
#import "SDLRPCParameterNames.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLTextField.h"
#import "SDLTextFieldName.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

QuickSpecBegin(SDLWindowCapabilitySpec)

__block SDLWindowCapability *testStruct = nil;

__block SDLTextField* testTextField = nil;
__block SDLImageField *testImageField = nil;
__block SDLButtonCapabilities *testButtonCapabilities = nil;
__block SDLSoftButtonCapabilities *testSoftButtonsCapabilities = nil;
__block SDLImageType testImageType = nil;
__block NSString *testTextName = nil;
__block NSString *testImageName = nil;
__block NSString *testTemplateAvailable = nil;
__block SDLMenuLayout testMenuLayout = SDLMenuLayoutTiles;
__block SDLDynamicUpdateCapabilities *testDynamicUpdates = nil;
__block NSArray<SDLTextField *> *textFields = nil;
__block NSArray<SDLImageField *> *imageFields = nil;
__block NSArray<SDLButtonCapabilities *> *buttonCapabilities = nil;
__block SDLKeyboardCapabilities *keyboardCapabilities = nil;
__block id windowID = nil;
__block id numCustomPresetsAvailable = nil;
__block NSArray<SDLImageType> *imageTypeSupported = nil;
__block NSArray<NSString *> *templatesAvailable = nil;
__block NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities = nil;
__block NSArray<SDLMenuLayout> *menuLayoutsAvailable = nil;

describe(@"getter/setter tests", ^{
    beforeEach(^{
        testImageType = SDLImageTypeDynamic;
        testTextName = @"test Text field";
        testImageName = @"test Image field";

        testTextField = [[SDLTextField alloc] init];
        testTextField.name = SDLTextFieldNameTertiaryText;
        testImageField = [[SDLImageField alloc] init];
        testImageField.name = testImageName;

        testButtonCapabilities = [[SDLButtonCapabilities alloc] init];
        testButtonCapabilities.name = SDLButtonNameOk;
        testButtonCapabilities.shortPressAvailable = @YES;
        testButtonCapabilities.longPressAvailable = @YES;
        testButtonCapabilities.upDownAvailable = @YES;

        testSoftButtonsCapabilities = [[SDLSoftButtonCapabilities alloc] init];
        testSoftButtonsCapabilities.imageSupported = @YES;

        testTemplateAvailable = @"myTemplate";
        testDynamicUpdates = [[SDLDynamicUpdateCapabilities alloc] initWithSupportedDynamicImageFieldNames:@[SDLImageFieldNameSubMenuIcon] supportsDynamicSubMenus:@YES];

        textFields = @[testTextField];
        imageFields = @[testImageField];
        buttonCapabilities = @[testButtonCapabilities];
        keyboardCapabilities = [[SDLKeyboardCapabilities alloc] init];
        windowID = @444;
        numCustomPresetsAvailable = @10;
        imageTypeSupported = @[testImageType];
        templatesAvailable = @[testTemplateAvailable];
        softButtonCapabilities = @[testSoftButtonsCapabilities];
        menuLayoutsAvailable = @[testMenuLayout];
    });

    context(@"init", ^{
        beforeEach(^{
            testStruct = [[SDLWindowCapability alloc] init];
        });

        it(@"expect all properties to be nil", ^{
            expect(testStruct.windowID).to(beNil());
            expect(testStruct.textFields.firstObject.name).to(beNil());
            expect(testStruct.imageFields.firstObject.name).to(beNil());
            expect(testStruct.numCustomPresetsAvailable).to(beNil());
            expect(testStruct.buttonCapabilities.firstObject.name).to(beNil());
            expect(testStruct.buttonCapabilities.firstObject.shortPressAvailable).to(beNil());
            expect(testStruct.buttonCapabilities.firstObject.longPressAvailable).to(beNil());
            expect(testStruct.buttonCapabilities.firstObject.name).to(beNil());
            expect(testStruct.softButtonCapabilities.firstObject.imageSupported).to(beNil());
            expect(testStruct.menuLayoutsAvailable).to(beNil());
            expect(testStruct.templatesAvailable).to(beNil());
            expect(testStruct.dynamicUpdateCapabilities).to(beNil());
            expect(testStruct.imageTypeSupported).to(beNil());
            expect(testStruct.keyboardCapabilities).to(beNil());
        });
    });

    context(@"init and assign", ^{
        beforeEach(^{
            testStruct = [[SDLWindowCapability alloc] init];
            testStruct.windowID = windowID;
            testStruct.numCustomPresetsAvailable = numCustomPresetsAvailable;
            testStruct.textFields = @[testTextField];
            testStruct.imageFields = @[testImageField];
            testStruct.imageTypeSupported = @[testImageType];
            testStruct.buttonCapabilities = @[testButtonCapabilities];
            testStruct.softButtonCapabilities = @[testSoftButtonsCapabilities];
            testStruct.menuLayoutsAvailable = @[testMenuLayout];
            testStruct.templatesAvailable = @[testTemplateAvailable];
            testStruct.dynamicUpdateCapabilities = testDynamicUpdates;
            testStruct.keyboardCapabilities = keyboardCapabilities;
        });

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.windowID).to(equal(windowID));
            expect(testStruct.textFields.firstObject.name).to(equal(SDLTextFieldNameTertiaryText));
            expect(testStruct.imageFields.firstObject.name).to(equal(testImageName));
            expect(testStruct.numCustomPresetsAvailable).to(equal(numCustomPresetsAvailable));
            expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
            expect(testStruct.buttonCapabilities.firstObject.shortPressAvailable).to(equal(@YES));
            expect(testStruct.buttonCapabilities.firstObject.longPressAvailable).to(equal(@YES));
            expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
            expect(testStruct.softButtonCapabilities.firstObject.imageSupported).to(equal(@YES));
            expect(testStruct.menuLayoutsAvailable).to(equal(@[testMenuLayout]));
            expect(testStruct.templatesAvailable).to(equal(@[testTemplateAvailable]));
            expect(testStruct.dynamicUpdateCapabilities).to(equal(testDynamicUpdates));
            expect(testStruct.imageTypeSupported).to(equal(@[testImageType]));
            expect(testStruct.keyboardCapabilities).to(equal(keyboardCapabilities));
        });
    });

    context(@"initWithWindowID:textFields:imageFields:imageTypeSupported:templatesAvailable:numCustomPresetsAvailable:buttonCapabilities:softButtonCapabilities:menuLayoutsAvailable:dynamicUpdateCapabilities:", ^{
        beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testStruct = [[SDLWindowCapability alloc] initWithWindowID:windowID textFields:textFields imageFields:imageFields imageTypeSupported:imageTypeSupported templatesAvailable:templatesAvailable numCustomPresetsAvailable:numCustomPresetsAvailable buttonCapabilities:buttonCapabilities softButtonCapabilities:softButtonCapabilities menuLayoutsAvailable:menuLayoutsAvailable dynamicUpdateCapabilities:testDynamicUpdates];
#pragma clang diagnostic pop
        });

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.windowID).to(equal(windowID));
            expect(testStruct.textFields.firstObject.name).to(equal(SDLTextFieldNameTertiaryText));
            expect(testStruct.imageFields.firstObject.name).to(equal(testImageName));
            expect(testStruct.numCustomPresetsAvailable).to(equal(numCustomPresetsAvailable));
            expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
            expect(testStruct.buttonCapabilities.firstObject.shortPressAvailable).to(equal(@YES));
            expect(testStruct.buttonCapabilities.firstObject.longPressAvailable).to(equal(@YES));
            expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
            expect(testStruct.softButtonCapabilities.firstObject.imageSupported).to(equal(@YES));
            expect(testStruct.menuLayoutsAvailable).to(equal(@[testMenuLayout]));
            expect(testStruct.templatesAvailable).to(equal(@[testTemplateAvailable]));
            expect(testStruct.dynamicUpdateCapabilities).to(equal(testDynamicUpdates));
            expect(testStruct.imageTypeSupported).to(equal(@[testImageType]));
            expect(testStruct.keyboardCapabilities).to(beNil());
        });
    });

    context(@"initWithWindowID:textFields:imageFields:imageTypeSupported:templatesAvailable:numCustomPresetsAvailable:buttonCapabilities:softButtonCapabilities:menuLayoutsAvailable:dynamicUpdateCapabilities:keyboardCapabilities:", ^{
        beforeEach(^{
            testStruct = [[SDLWindowCapability alloc] initWithWindowID:windowID textFields:textFields imageFields:imageFields imageTypeSupported:imageTypeSupported templatesAvailable:templatesAvailable numCustomPresetsAvailable:numCustomPresetsAvailable buttonCapabilities:buttonCapabilities softButtonCapabilities:softButtonCapabilities menuLayoutsAvailable:menuLayoutsAvailable dynamicUpdateCapabilities:testDynamicUpdates keyboardCapabilities:keyboardCapabilities];
        });

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.windowID).to(equal(windowID));
            expect(testStruct.textFields.firstObject.name).to(equal(SDLTextFieldNameTertiaryText));
            expect(testStruct.imageFields.firstObject.name).to(equal(testImageName));
            expect(testStruct.numCustomPresetsAvailable).to(equal(numCustomPresetsAvailable));
            expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
            expect(testStruct.buttonCapabilities.firstObject.shortPressAvailable).to(equal(@YES));
            expect(testStruct.buttonCapabilities.firstObject.longPressAvailable).to(equal(@YES));
            expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
            expect(testStruct.softButtonCapabilities.firstObject.imageSupported).to(equal(@YES));
            expect(testStruct.menuLayoutsAvailable).to(equal(@[testMenuLayout]));
            expect(testStruct.templatesAvailable).to(equal(@[testTemplateAvailable]));
            expect(testStruct.dynamicUpdateCapabilities).to(equal(testDynamicUpdates));
            expect(testStruct.imageTypeSupported).to(equal(@[testImageType]));
            expect(testStruct.keyboardCapabilities).to(equal(keyboardCapabilities));
        });
    });
});

describe(@"creating a valid keyboard configuration based on keyboard capabilities", ^{
    UInt8 numConfigurableKeys = 7;

    beforeEach(^{
        testStruct = [[SDLWindowCapability alloc] init];
        testStruct.keyboardCapabilities = nil;
    });

    context(@"when keyboardCapabilities is nil or empty", ^{
        it(@"result should be nil when the argument is nil", ^{
            SDLKeyboardProperties *resultProperties = [testStruct createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:nil];
            expect(resultProperties).to(beNil());
        });

        it(@"result should be equal to the argument when keyboardLayout is nil", ^{
            SDLKeyboardProperties *testKeyboardProperties = [[SDLKeyboardProperties alloc] init];
            testKeyboardProperties.maskInputCharacters = SDLKeyboardInputMaskUserChoiceInputKeyMask;
            SDLKeyboardProperties *resultProperties = [testStruct createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:testKeyboardProperties];
            expect(resultProperties).notTo(beNil());
            expect(resultProperties).to(equal(testKeyboardProperties));
            expect(resultProperties.maskInputCharacters).to(equal(SDLKeyboardInputMaskUserChoiceInputKeyMask));
        });

        it(@"result should be nil when the argument is not nil and keyboardCapabilities is empty", ^{
            testStruct.keyboardCapabilities = [[SDLKeyboardCapabilities alloc] init];
            SDLKeyboardProperties *testKeyboardProperties = [[SDLKeyboardProperties alloc] init];
            testKeyboardProperties.keyboardLayout = SDLKeyboardLayoutNumeric;
            testKeyboardProperties.maskInputCharacters = SDLKeyboardInputMaskUserChoiceInputKeyMask;
            SDLKeyboardProperties *resultProperties = [testStruct createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:testKeyboardProperties];
            expect(resultProperties).to(beNil());
        });

        context(@"when keyboardCapabilities is not empty", ^{
            __block SDLKeyboardProperties *testKeyboardProperties = nil;
            __block SDLKeyboardCapabilities *keyboardCapabilities = nil;
            __block NSArray *testCustomKeysLong = nil;

            beforeEach(^{
                // create a long array that contains more custom keys than <numConfigurableKeys>
                testCustomKeysLong = [@"a ä æ b c d e ê f j h i j k l m n o p q r s ß t u v w x y z" componentsSeparatedByString:@" "];
                NSArray *arrayLayouts = @[SDLKeyboardLayoutQWERTY, SDLKeyboardLayoutQWERTZ, SDLKeyboardLayoutAZERTY, SDLKeyboardLayoutNumeric];
                NSMutableArray *arrayLayoutCapability = [[NSMutableArray alloc] initWithCapacity:arrayLayouts.count];
                for (SDLKeyboardLayout layout in arrayLayouts) {
                    SDLKeyboardLayoutCapability *layoutCapability = [[SDLKeyboardLayoutCapability alloc] initWithKeyboardLayout:layout numConfigurableKeys:numConfigurableKeys];
                    [arrayLayoutCapability addObject:layoutCapability];
                }
                keyboardCapabilities = [[SDLKeyboardCapabilities alloc] init];
                keyboardCapabilities.supportedKeyboards = arrayLayoutCapability;
                testStruct.keyboardCapabilities = keyboardCapabilities;

                testKeyboardProperties = [[SDLKeyboardProperties alloc] init];
                testKeyboardProperties.keyboardLayout = SDLKeyboardLayoutNumeric;
                // create custom keys array longer than <numConfigurableKeys>
                testKeyboardProperties.customKeys = testCustomKeysLong;
                testKeyboardProperties.maskInputCharacters = SDLKeyboardInputMaskUserChoiceInputKeyMask;
                testKeyboardProperties.keyboardLayout = SDLKeyboardLayoutAZERTY;
            });

            it(@"maskInputCharacters should not be nil when maskInputCharactersSupported = YES", ^{
                keyboardCapabilities.maskInputCharactersSupported = @YES;
                SDLKeyboardProperties *resultProperties = [testStruct createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:testKeyboardProperties];
                expect(resultProperties).notTo(beNil());
                expect(resultProperties).notTo(equal(testKeyboardProperties));
                expect(resultProperties.customKeys.count).to(equal(numConfigurableKeys));
                expect(resultProperties.maskInputCharacters).to(equal(SDLKeyboardInputMaskUserChoiceInputKeyMask));
            });

            it(@"maskInputCharacters should be nil when maskInputCharactersSupported = NO", ^{
                keyboardCapabilities.maskInputCharactersSupported = @NO;
                SDLKeyboardProperties *resultProperties = [testStruct createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:testKeyboardProperties];
                expect(resultProperties).notTo(beNil());
                expect(resultProperties).notTo(equal(testKeyboardProperties));
                expect(resultProperties.customKeys.count).to(equal(numConfigurableKeys));
                expect(resultProperties.maskInputCharacters).to(beNil());
            });

            it(@"customKeys should be trimmed to contain <numConfigurableKeys> items", ^{
                NSArray *expectedCustomKeys = [testCustomKeysLong subarrayWithRange:NSMakeRange(0, numConfigurableKeys)];
                testKeyboardProperties.customKeys = testCustomKeysLong;
                SDLKeyboardProperties *resultProperties = [testStruct createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:testKeyboardProperties];
                expect(resultProperties).notTo(beNil());
                expect(resultProperties.customKeys.count).to(equal(numConfigurableKeys));
                expect(resultProperties.customKeys).to(equal(expectedCustomKeys));
            });

            it(@"customKeys should not be trimmed and should be equal to the initial array", ^{
                NSArray *testCustomKeys = [testCustomKeysLong subarrayWithRange:NSMakeRange(0, numConfigurableKeys)];
                testKeyboardProperties.customKeys = testCustomKeys;
                SDLKeyboardProperties *resultProperties = [testStruct createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:testKeyboardProperties];
                expect(resultProperties).notTo(beNil());
                expect(resultProperties.customKeys.count).to(equal(numConfigurableKeys));
                expect(resultProperties.customKeys).to(equal(testCustomKeys));
            });
        });
    });
});

QuickSpecEnd
