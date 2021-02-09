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
#import "SDLRPCParameterNames.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLTextField.h"
#import "SDLTextFieldName.h"
#import "SDLWindowCapability.h"

QuickSpecBegin(SDLWindowCapabilitySpec)

NSString *testTemplateAvailable = @"myTemplate";
SDLTextField *testTextField = [[SDLTextField alloc] init];
NSArray<SDLTextField *> *textFields = @[testTextField];
NSString *textFieldName = @"t.f.name";
testTextField.name = textFieldName;
SDLImageField *testImageField = [[SDLImageField alloc] init];
NSArray<SDLImageField *> *imageFields = @[testImageField];
NSString *testImageName = @"test Image field";
testImageField.name = testImageName;
SDLButtonCapabilities *testButtonCapabilities = [[SDLButtonCapabilities alloc] init];
NSArray<SDLButtonCapabilities *> *buttonCapabilities = @[testButtonCapabilities];
testButtonCapabilities.name = SDLButtonNameOk;
testButtonCapabilities.shortPressAvailable = @YES;
testButtonCapabilities.longPressAvailable = @YES;
testButtonCapabilities.upDownAvailable = @YES;
SDLSoftButtonCapabilities *testSoftButtonsCapabilities = [[SDLSoftButtonCapabilities alloc] init];
testSoftButtonsCapabilities.imageSupported = @YES;
SDLImageType testImageType = SDLImageTypeDynamic;
SDLMenuLayout testMenuLayout = SDLMenuLayoutTiles;
SDLDynamicUpdateCapabilities *testDynamicUpdates = [[SDLDynamicUpdateCapabilities alloc] initWithSupportedDynamicImageFieldNames:@[SDLImageFieldNameSubMenuIcon] supportsDynamicSubMenus:@YES];
SDLKeyboardCapabilities *keyboardCapabilities = [[SDLKeyboardCapabilities alloc] init];
id windowID = @444;
id numCustomPresetsAvailable = @10;
NSArray<SDLImageType> *imageTypeSupported = @[testImageType];
NSArray<NSString *> *templatesAvailable = @[testTemplateAvailable];
NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities = @[testSoftButtonsCapabilities];
NSArray<SDLMenuLayout> *menuLayoutsAvailable = @[testMenuLayout];
__block SDLWindowCapability *testStruct = nil;

describe(@"getter/setter tests", ^{
    afterEach(^{
        testStruct = nil;
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

        it(@"expect to be set properly", ^{
            expect(testStruct.windowID).to(equal(windowID));
            expect(testStruct.textFields.firstObject.name).to(equal(textFieldName));
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
            testStruct = [[SDLWindowCapability alloc] initWithWindowID:windowID textFields:textFields imageFields:imageFields imageTypeSupported:imageTypeSupported templatesAvailable:templatesAvailable numCustomPresetsAvailable:numCustomPresetsAvailable buttonCapabilities:buttonCapabilities softButtonCapabilities:softButtonCapabilities menuLayoutsAvailable:menuLayoutsAvailable dynamicUpdateCapabilities:testDynamicUpdates];
        });

        it(@"expect to be set properly", ^{
            expect(testStruct.windowID).to(equal(windowID));
            expect(testStruct.textFields.firstObject.name).to(equal(textFieldName));
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

        it(@"expect to be set properly", ^{
            expect(testStruct.windowID).to(equal(windowID));
            expect(testStruct.textFields.firstObject.name).to(equal(textFieldName));
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

QuickSpecEnd
