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

QuickSpecEnd
