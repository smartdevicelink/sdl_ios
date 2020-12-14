//
//  SDLWindowCapabilitySpec.m
//  SmartDeviceLinkTests

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLWindowCapability.h"

#import "SDLButtonCapabilities.h"
#import "SDLDynamicUpdateCapabilities.h"
#import "SDLImageField.h"
#import "SDLImageType.h"
#import "SDLRPCParameterNames.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLTextField.h"
#import "SDLTextFieldName.h"


@interface SDLWindowCapability()

- (NSUInteger)maxNumberOfMainFieldLines;
- (NSUInteger)maxNumberOfAlertFieldLines;

@end

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

describe(@"Getter/Setter Tests", ^ {
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
    });
    
    it(@"Should set and get correctly", ^ {
        testStruct = [[SDLWindowCapability alloc] init];
        testStruct.windowID = @444;
        testStruct.numCustomPresetsAvailable = @10;
        testStruct.textFields = @[testTextField];
        testStruct.imageFields = @[testImageField];
        testStruct.imageTypeSupported = @[testImageType];
        testStruct.buttonCapabilities = @[testButtonCapabilities];
        testStruct.softButtonCapabilities = @[testSoftButtonsCapabilities];
        testStruct.menuLayoutsAvailable = @[testMenuLayout];
        testStruct.templatesAvailable = @[testTemplateAvailable];
        testStruct.dynamicUpdateCapabilities = testDynamicUpdates;
        
        expect(testStruct.windowID).to(equal(@444));
        expect(testStruct.textFields.firstObject.name).to(equal(SDLTextFieldNameTertiaryText));
        expect(testStruct.imageFields.firstObject.name).to(equal(testImageName));
        expect(testStruct.numCustomPresetsAvailable).to(equal(@10));
        expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
        expect(testStruct.buttonCapabilities.firstObject.shortPressAvailable).to(equal(@YES));
        expect(testStruct.buttonCapabilities.firstObject.longPressAvailable).to(equal(@YES));
        expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
        expect(testStruct.softButtonCapabilities.firstObject.imageSupported).to(equal(@YES));
        expect(testStruct.menuLayoutsAvailable).to(equal(@[testMenuLayout]));
        expect(testStruct.templatesAvailable).to(equal(@[testTemplateAvailable]));
        expect(testStruct.dynamicUpdateCapabilities).to(equal(testDynamicUpdates));
    });
});

describe(@"initializing with ", ^{
    beforeEach(^{
        testStruct = [[SDLWindowCapability alloc] initWithWindowID:@444 textFields:@[testTextField] imageFields:@[testImageField] imageTypeSupported:@[testImageType] templatesAvailable:@[testTemplateAvailable] numCustomPresetsAvailable:@10 buttonCapabilities:@[testButtonCapabilities] softButtonCapabilities:@[testSoftButtonsCapabilities] menuLayoutsAvailable:@[testMenuLayout] dynamicUpdateCapabilities:testDynamicUpdates];
    });

    it(@"Should set and get correctly", ^ {
        testStruct = [[SDLWindowCapability alloc] init];
        testStruct.windowID = @444;
        testStruct.numCustomPresetsAvailable = @10;
        testStruct.textFields = @[testTextField];
        testStruct.imageFields = @[testImageField];
        testStruct.imageTypeSupported = @[testImageType];
        testStruct.buttonCapabilities = @[testButtonCapabilities];
        testStruct.softButtonCapabilities = @[testSoftButtonsCapabilities];
        testStruct.menuLayoutsAvailable = @[testMenuLayout];
        testStruct.templatesAvailable = @[testTemplateAvailable];
        testStruct.dynamicUpdateCapabilities = testDynamicUpdates;

        expect(testStruct.windowID).to(equal(@444));
        expect(testStruct.textFields.firstObject.name).to(equal(SDLTextFieldNameTertiaryText));
        expect(testStruct.imageFields.firstObject.name).to(equal(testImageName));
        expect(testStruct.numCustomPresetsAvailable).to(equal(@10));
        expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
        expect(testStruct.buttonCapabilities.firstObject.shortPressAvailable).to(equal(@YES));
        expect(testStruct.buttonCapabilities.firstObject.longPressAvailable).to(equal(@YES));
        expect(testStruct.buttonCapabilities.firstObject.name).to(equal(SDLButtonNameOk));
        expect(testStruct.softButtonCapabilities.firstObject.imageSupported).to(equal(@YES));
        expect(testStruct.menuLayoutsAvailable).to(equal(@[testMenuLayout]));
        expect(testStruct.templatesAvailable).to(equal(@[testTemplateAvailable]));
        expect(testStruct.dynamicUpdateCapabilities).to(equal(testDynamicUpdates));
    });
});

describe(@"extensions", ^{
    describe(@"getting the max number of main field lines", ^{
        __block SDLTextField *testTextField1 = nil;
        __block SDLTextField *testTextField2 = nil;
        __block SDLTextField *testTextField3 = nil;
        __block SDLTextField *testTextField4 = nil;

        beforeEach(^{
            testTextField1 = [[SDLTextField alloc] init];
            testTextField1.name = SDLTextFieldNameMainField1;

            testTextField2 = [[SDLTextField alloc] init];
            testTextField2.name = SDLTextFieldNameMainField2;

            testTextField3 = [[SDLTextField alloc] init];
            testTextField3.name = SDLTextFieldNameMainField3;

            testTextField4 = [[SDLTextField alloc] init];
            testTextField4.name = SDLTextFieldNameMainField4;

            testStruct = [[SDLWindowCapability alloc] init];
        });

        it(@"should return 0 if none of the text fields are supported", ^ {
            testStruct.textFields = @[];
            NSUInteger maxNumberOfMainFieldLines = [testStruct maxNumberOfMainFieldLines];

            expect(maxNumberOfMainFieldLines).to(equal(0));
        });

        it(@"should return 1 if only one text field is supported", ^ {
            testStruct.textFields = @[testTextField1];
            NSUInteger maxNumberOfMainFieldLines = [testStruct maxNumberOfMainFieldLines];

            expect(maxNumberOfMainFieldLines).to(equal(1));
        });

        it(@"should return 2 if two text fields are supported", ^ {
            testStruct.textFields = @[testTextField2, testTextField1];
            NSUInteger maxNumberOfMainFieldLines = [testStruct maxNumberOfMainFieldLines];

            expect(maxNumberOfMainFieldLines).to(equal(2));
        });

        it(@"should return 3 if all the text fields are supported", ^ {
            testStruct.textFields = @[testTextField2, testTextField1, testTextField3];
            NSUInteger maxNumberOfMainFieldLines = [testStruct maxNumberOfMainFieldLines];

            expect(maxNumberOfMainFieldLines).to(equal(3));
        });

        it(@"should return 4 if all the text fields are supported", ^ {
            testStruct.textFields = @[testTextField1, testTextField2, testTextField3, testTextField4];
            NSUInteger maxNumberOfMainFieldLines = [testStruct maxNumberOfMainFieldLines];

            expect(maxNumberOfMainFieldLines).to(equal(4));
        });
    });

    describe(@"getting the max number of alert text field lines", ^{
        __block SDLTextField *testAlertTextField1 = nil;
        __block SDLTextField *testAlertTextField2 = nil;
        __block SDLTextField *testAlertTextField3 = nil;

        beforeEach(^{
            testAlertTextField1 = [[SDLTextField alloc] init];
            testAlertTextField1.name = SDLTextFieldNameAlertText1;

            testAlertTextField2 = [[SDLTextField alloc] init];
            testAlertTextField2.name = SDLTextFieldNameAlertText2;

            testAlertTextField3 = [[SDLTextField alloc] init];
            testAlertTextField3.name = SDLTextFieldNameAlertText3;

            testStruct = [[SDLWindowCapability alloc] init];
        });

        it(@"should return 0 if none of the text fields are supported", ^ {
            testStruct.textFields = @[];
            NSUInteger maxNumberOfAlertMainFieldLines = [testStruct maxNumberOfAlertFieldLines];

            expect(maxNumberOfAlertMainFieldLines).to(equal(0));
        });

        it(@"should return 1 if only one text field is supported", ^ {
            testStruct.textFields = @[testAlertTextField1];
            NSUInteger maxNumberOfAlertMainFieldLines = [testStruct maxNumberOfAlertFieldLines];

            expect(maxNumberOfAlertMainFieldLines).to(equal(1));
        });

        it(@"should return 2 if two text fields are supported", ^ {
            testStruct.textFields = @[testAlertTextField1, testAlertTextField2];
            NSUInteger maxNumberOfAlertMainFieldLines = [testStruct maxNumberOfAlertFieldLines];

            expect(maxNumberOfAlertMainFieldLines).to(equal(2));
        });

        it(@"should return 3 if all the text fields are supported", ^ {
            testStruct.textFields = @[testAlertTextField1, testAlertTextField2, testAlertTextField3];
            NSUInteger maxNumberOfAlertMainFieldLines = [testStruct maxNumberOfAlertFieldLines];

            expect(maxNumberOfAlertMainFieldLines).to(equal(3));
        });
    });
});

QuickSpecEnd
