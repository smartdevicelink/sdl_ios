#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import <SmartDeviceLink/SmartDeviceLink.h>

#import "SDLMenuManager.h"
#import "TestConnectionManager.h"
#import "SDLGlobals.h"


@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;

@end

@interface SDLMenuManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;


@property (strong, nonatomic, nullable) NSArray<SDLRPCRequest *> *inProgressUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (assign, nonatomic) BOOL waitingOnHMIUpdate;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *waitingUpdateMenuCells;
@property (strong, nonatomic, nullable) SDLWindowCapability *windowCapability;

@property (assign, nonatomic) UInt32 lastMenuId;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *oldMenuCells;

- (BOOL)sdl_shouldRPCsIncludeImages:(NSArray<SDLMenuCell *> *)cells;

@end

QuickSpecBegin(SDLMenuManagerSpec)

describe(@"menu manager", ^{
    __block SDLMenuManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = nil;
    __block SDLFileManager *mockFileManager = nil;
    __block SDLSystemCapabilityManager *mockSystemCapabilityManager = nil;
    __block SDLArtwork *testArtwork = nil;
    __block SDLArtwork *testArtwork2 = nil;
    __block SDLArtwork *testArtwork3 = nil;

    __block SDLMenuCell *textOnlyCell = nil;
    __block SDLMenuCell *textOnlyCell2 = nil;
    __block SDLMenuCell *textAndImageCell = nil;
    __block SDLMenuCell *textAndImageCell2 = nil;
    __block SDLMenuCell *submenuCell = nil;
    __block SDLMenuCell *submenuCell2 = nil;
    __block SDLMenuCell *submenuImageCell = nil;

    __block SDLMenuConfiguration *testMenuConfiguration = nil;

    __block SDLVersion *menuUniquenessActiveVersion = nil;

    beforeEach(^{
        testArtwork = [[SDLArtwork alloc] initWithData:[@"Test data" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name" fileExtension:@"png" persistent:NO];
        testArtwork2 = [[SDLArtwork alloc] initWithData:[@"Test data 2" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name 2" fileExtension:@"png" persistent:NO];
        testArtwork3 = [[SDLArtwork alloc] initWithData:[@"Test data 3" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name" fileExtension:@"png" persistent:NO];
        testArtwork3.overwrite = YES;

        textOnlyCell = [[SDLMenuCell alloc] initWithTitle:@"Test 1" icon:nil voiceCommands:nil secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:testArtwork voiceCommands:nil secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        textAndImageCell2 = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:testArtwork2 voiceCommands:nil secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        submenuCell = [[SDLMenuCell alloc] initWithTitle:@"Test 3" icon:nil submenuLayout:nil subCells:@[textOnlyCell, textAndImageCell] secondaryText:nil tertiaryText:nil secondaryArtwork:nil];
        submenuCell2 = [[SDLMenuCell alloc] initWithTitle:@"Test 3" icon:nil submenuLayout:nil subCells:@[textAndImageCell, textAndImageCell2] secondaryText:nil tertiaryText:nil secondaryArtwork:nil];
        submenuImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 4" icon:testArtwork2 submenuLayout:SDLMenuLayoutTiles subCells:@[textOnlyCell] secondaryText:nil tertiaryText:nil secondaryArtwork:nil];
        textOnlyCell2 = [[SDLMenuCell alloc] initWithTitle:@"Test 5" icon:nil voiceCommands:nil secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

        testMenuConfiguration = [[SDLMenuConfiguration alloc] initWithMainMenuLayout:SDLMenuLayoutTiles defaultSubmenuLayout:SDLMenuLayoutList];


        mockConnectionManager = [[TestConnectionManager alloc] init];
        mockFileManager = OCMClassMock([SDLFileManager class]);
        mockSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);
        testManager = [[SDLMenuManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager];

        SDLImageField *commandIconField = [[SDLImageField alloc] init];
        commandIconField.name = SDLImageFieldNameCommandIcon;
        SDLImageField *subMenuSecondaryArtworkField = [[SDLImageField alloc] init];
        subMenuSecondaryArtworkField.name = SDLImageFieldNameMenuSubMenuSecondaryImage;
        SDLImageField *commandSecondaryArtworkField = [[SDLImageField alloc] init];
        commandSecondaryArtworkField.name = SDLImageFieldNameMenuCommandSecondaryImage;
        SDLWindowCapability *windowCapability = [[SDLWindowCapability alloc] init];
        windowCapability.windowID = @(SDLPredefinedWindowsDefaultWindow);
        windowCapability.imageFields = @[commandIconField, subMenuSecondaryArtworkField, commandSecondaryArtworkField];
        windowCapability.imageTypeSupported = @[SDLImageTypeDynamic, SDLImageTypeStatic];
        windowCapability.menuLayoutsAvailable = @[SDLMenuLayoutList, SDLMenuLayoutTiles];
        testManager.windowCapability = windowCapability;
        menuUniquenessActiveVersion = [[SDLVersion alloc] initWithMajor:7 minor:1 patch:0];
    });

    it(@"should instantiate correctly", ^{
        expect(testManager.menuCells).to(beEmpty());
        expect(testManager.connectionManager).to(equal(mockConnectionManager));
        expect(testManager.fileManager).to(equal(mockFileManager));
        expect(testManager.systemCapabilityManager).to(equal(mockSystemCapabilityManager));
        expect(testManager.currentHMILevel).to(beNil());
        expect(testManager.inProgressUpdate).to(beNil());
        expect(testManager.hasQueuedUpdate).to(beFalse());
        expect(testManager.waitingOnHMIUpdate).to(beFalse());
        expect(testManager.lastMenuId).to(equal(1));
        expect(testManager.oldMenuCells).to(beEmpty());
        expect(testManager.waitingUpdateMenuCells).to(beNil());
        expect(testManager.menuConfiguration).toNot(beNil());
    });

    describe(@"updating menu cells before HMI is ready", ^{
        context(@"when in HMI NONE", ^{
            beforeEach(^{
                testManager.currentHMILevel = SDLHMILevelNone;
                testManager.menuCells = @[textOnlyCell];
            });

            it(@"should not update", ^{
                expect(mockConnectionManager.receivedRequests).to(beEmpty());
            });

            describe(@"when entering the foreground", ^{
                beforeEach(^{
                    SDLOnHMIStatus *onHMIStatus = [[SDLOnHMIStatus alloc] init];
                    onHMIStatus.hmiLevel = SDLHMILevelFull;
                    onHMIStatus.systemContext = SDLSystemContextMain;

                    SDLRPCNotificationNotification *testSystemContextNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:onHMIStatus];
                    [[NSNotificationCenter defaultCenter] postNotification:testSystemContextNotification];
                });

                it(@"should update", ^{
                    expect(mockConnectionManager.receivedRequests).toNot(beEmpty());
                });
            });
        });

        context(@"when no HMI level has been received", ^{
            beforeEach(^{
                testManager.currentHMILevel = nil;
            });

            it(@"should not update the menu configuration", ^{
                testManager.menuConfiguration = testMenuConfiguration;
                expect(mockConnectionManager.receivedRequests).to(beEmpty());
                expect(testManager.menuConfiguration).toNot(equal(testMenuConfiguration));
            });

            it(@"should not update the menu cells", ^{
                testManager.menuCells = @[textOnlyCell];
                expect(mockConnectionManager.receivedRequests).to(beEmpty());
            });
        });

        context(@"when in the menu", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"6.0.0"];
                testManager.currentHMILevel = SDLHMILevelFull;
                testManager.currentSystemContext = SDLSystemContextMenu;
            });

            it(@"should update the menu configuration", ^{
                testManager.menuConfiguration = testMenuConfiguration;
                expect(mockConnectionManager.receivedRequests).toNot(beEmpty());
                expect(testManager.menuConfiguration).to(equal(testMenuConfiguration));
            });
        });
    });

    describe(@"updating menu cells", ^{
        beforeEach(^{
            testManager.currentHMILevel = SDLHMILevelFull;
            testManager.currentSystemContext = SDLSystemContextMain;
        });

        context(@"duplicate titles version >= 7.1.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = menuUniquenessActiveVersion;
            });

            it(@"should not update the cells' unique title", ^{
                testManager.menuCells = @[textAndImageCell, textAndImageCell2];
                expect(testManager.menuCells).toNot(beEmpty());
                expect(testManager.menuCells.firstObject.uniqueTitle).to(equal("Test 2"));
                expect(testManager.menuCells.lastObject.uniqueTitle).to(equal("Test 2"));
            });

            it(@"should not update subcells' unique title", ^{
                testManager.menuCells = @[submenuCell2];
                expect(testManager.menuCells).toNot(beEmpty());
                expect(testManager.menuCells.firstObject.subCells.firstObject.uniqueTitle).to(equal("Test 2"));
                expect(testManager.menuCells.firstObject.subCells.lastObject.uniqueTitle).to(equal("Test 2"));
            });
        });

        context(@"duplicate titles version <= 7.1.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [[SDLVersion alloc] initWithMajor:7 minor:0 patch:0];
            });

            it(@"append a number to the unique text for main menu cells", ^{
                testManager.menuCells = @[textAndImageCell, textAndImageCell2];
                expect(testManager.menuCells).toNot(beEmpty());
                expect(testManager.menuCells.firstObject.uniqueTitle).to(equal("Test 2"));
                expect(testManager.menuCells.lastObject.uniqueTitle).to(equal("Test 2 (2)"));
            });

            it(@"should append a number to the unique text for subcells", ^{
                testManager.menuCells = @[submenuCell2];
                expect(testManager.menuCells).toNot(beEmpty());
                expect(testManager.menuCells.firstObject.subCells.firstObject.uniqueTitle).to(equal("Test 2"));
                expect(testManager.menuCells.firstObject.subCells.lastObject.uniqueTitle).to(equal("Test 2 (2)"));
            });
        });

        context(@"when the cells contain duplicates", ^{
            SDLMenuCell *textCell = [[SDLMenuCell alloc] initWithTitle:@"Test 1" icon:nil voiceCommands:@[@"no", @"yes"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            SDLMenuCell *textCell2 = [[SDLMenuCell alloc] initWithTitle:@"Test 1" icon:nil voiceCommands:@[@"no", @"maybe"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

            it(@"should fail with duplicate cells", ^{
                testManager.menuCells = @[textCell, textCell2];
                expect(testManager.menuCells).to(beEmpty());
            });
        });

        context(@"when cells contain duplicate subcells", ^{
            SDLMenuCell *subCell1 = [[SDLMenuCell alloc] initWithTitle:@"subCell 1" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            SDLMenuCell *subCell2 = [[SDLMenuCell alloc] initWithTitle:@"subCell 1" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            SDLMenuCell *textCell = [[SDLMenuCell alloc] initWithTitle:@"Test 1" icon:nil submenuLayout:nil subCells:@[subCell1, subCell2]];

            it(@"should fail with duplicate cells", ^{
                testManager.menuCells = @[textCell];
                expect(testManager.menuCells).to(beEmpty());
            });
        });

        context(@"duplicate VR commands", ^{
            __block SDLMenuCell *textAndVRCell1 = [[SDLMenuCell alloc] initWithTitle:@"Test 1" icon:nil voiceCommands:@[@"Cat", @"Turtle"] secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            __block SDLMenuCell *textAndVRCell2 = [[SDLMenuCell alloc] initWithTitle:@"Test 3" icon:nil voiceCommands:@[@"Cat", @"Dog"] secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

            it(@"should fail when menu items have duplicate vr commands", ^{
                testManager.menuCells = @[textAndVRCell1, textAndVRCell2];
                expect(testManager.menuCells).to(beEmpty());
            });
        });

        context(@"when there are duplicate VR commands in subCells", ^{
            SDLMenuCell *textAndVRSubCell1 = [[SDLMenuCell alloc] initWithTitle:@"subCell 1" icon:nil voiceCommands:@[@"Cat"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            SDLMenuCell *textAndVRSubCell2 = [[SDLMenuCell alloc] initWithTitle:@"subCell 2" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            SDLMenuCell *textAndVRCell1 = [[SDLMenuCell alloc] initWithTitle:@"Test 1" icon:nil voiceCommands:@[@"Cat", @"Turtle"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            SDLMenuCell *textAndVRCell2 = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:nil submenuLayout:nil subCells:@[textAndVRSubCell1, textAndVRSubCell2]];

            it(@"should fail when menu items have duplicate vr commands", ^{
                testManager.menuCells = @[textAndVRCell1, textAndVRCell2];
                expect(testManager.menuCells).to(beEmpty());
            });
        });

        it(@"should check if all artworks are uploaded and return NO", ^{
            textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:nil voiceCommands:nil secondaryText:nil tertiaryText:nil secondaryArtwork:testArtwork handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            testManager.menuCells = @[textAndImageCell, textOnlyCell];
            OCMVerify([testManager sdl_shouldRPCsIncludeImages:testManager.menuCells]);
            expect([testManager sdl_shouldRPCsIncludeImages:testManager.menuCells]).to(beFalse());
        });

        it(@"should check if all artworks are uploaded and return NO", ^{
            textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:testArtwork3 voiceCommands:nil secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            testManager.menuCells = @[textAndImageCell, textOnlyCell];
            OCMVerify([testManager sdl_shouldRPCsIncludeImages:testManager.menuCells]);
            expect([testManager sdl_shouldRPCsIncludeImages:testManager.menuCells]).to(beFalse());
        });

        it(@"should properly update a text cell", ^{
            testManager.menuCells = @[textOnlyCell];

            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLDeleteCommand class]];
            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
            expect(deletes).to(beEmpty());

            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
            NSArray *add = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
            expect(add).toNot(beEmpty());
        });

        it(@"should properly update with subcells", ^{
            OCMStub([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
            testManager.menuCells = @[submenuCell];
            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

            NSPredicate *submenuCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
            NSArray *submenus = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:submenuCommandPredicate];

            expect(adds).to(haveCount(2));
            expect(submenus).to(haveCount(1));
        });

        describe(@"updating with an image", ^{
            context(@"when the image is already on the head unit", ^{
                beforeEach(^{
                    OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);
                });

                it(@"should check if all artworks are uploaded", ^{
                    textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:testArtwork3 voiceCommands:nil secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
                    testManager.menuCells = @[textAndImageCell, textOnlyCell];
                    OCMVerify([testManager sdl_shouldRPCsIncludeImages:testManager.menuCells]);
                    expect([testManager sdl_shouldRPCsIncludeImages:testManager.menuCells]).to(beTrue());
                });

                it(@"should properly update an image cell", ^{
                    testManager.menuCells = @[textAndImageCell, submenuImageCell];

                    NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
                    NSArray *add = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
                    SDLAddCommand *sentCommand = add.firstObject;

                    NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
                    NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
                    SDLAddSubMenu *sentSubmenu = submenu.firstObject;

                    expect(add).to(haveCount(1));
                    expect(submenu).to(haveCount(1));
                    expect(sentCommand.cmdIcon.value).to(equal(testArtwork.name));
                    expect(sentSubmenu.menuIcon.value).to(equal(testArtwork2.name));
                    OCMReject([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
                });

                it(@"should properly overwrite an image cell", ^{
                    OCMStub([mockFileManager fileNeedsUpload:[OCMArg isNotNil]]).andReturn(YES);
                    textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:testArtwork3 voiceCommands:nil secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
                    testManager.menuCells = @[textAndImageCell, submenuImageCell];
                    OCMVerify([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
                });
            });

            // No longer a valid unit test
            context(@"when the image is not on the head unit", ^{
                beforeEach(^{
                    testManager.dynamicMenuUpdatesMode = SDLDynamicMenuUpdatesModeForceOff;
                    OCMStub([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
                });

                it(@"should wait till image is on head unit and attempt to update without the image", ^{
                    testManager.menuCells = @[textAndImageCell, submenuImageCell];
                    
                    NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
                    NSArray *add = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
                    SDLAddCommand *sentCommand = add.firstObject;

                    NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
                    NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
                    SDLAddSubMenu *sentSubmenu = submenu.firstObject;

                    expect(add).to(haveCount(1));
                    expect(submenu).to(haveCount(1));
                    expect(sentCommand.cmdIcon.value).to(beNil());
                    expect(sentSubmenu.menuIcon.value).to(beNil());
                });
            });
        });

        describe(@"updating when a menu already exists with dynamic updates on", ^{
            beforeEach(^{
                testManager.dynamicMenuUpdatesMode = SDLDynamicMenuUpdatesModeForceOn;
                OCMStub([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
            });
            
            it(@"should send deletes first", ^{
                testManager.menuCells = @[textOnlyCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                testManager.menuCells = @[textAndImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                expect(deletes).to(haveCount(1));
                expect(adds).to(haveCount(2));
            });

            it(@"should send dynamic deletes first then dynamic adds case with 2 submenu cells", ^{
                testManager.menuCells = @[textOnlyCell, submenuCell, submenuImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                testManager.menuCells = @[submenuCell, submenuImageCell, textOnlyCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
                NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];

                expect(deletes).to(haveCount(1));
                expect(adds).to(haveCount(5));
                expect(submenu).to(haveCount(2));
            });

            it(@"should send dynamic deletes first then dynamic adds when removing one submenu cell", ^{
                testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *deleteSubCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteSubMenu class]];
                NSArray *subDeletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteSubCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
                NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];

                expect(deletes).to(haveCount(0));
                expect(subDeletes).to(haveCount(1));
                expect(adds).to(haveCount(5));
                expect(submenu).to(haveCount(2));
            });

            it(@"should send dynamic deletes first then dynamic adds when adding one new cell", ^{
                testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell, textOnlyCell2];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                
                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
                NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];

                expect(deletes).to(haveCount(0));
                expect(adds).to(haveCount(6));
                expect(submenu).to(haveCount(2));
            });

            it(@"should send dynamic deletes first then dynamic adds when cells stay the same", ^{
                testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                expect(deletes).to(haveCount(0));
                expect(adds).to(haveCount(3));
            });
        });

        describe(@"updating when a menu already exists with dynamic updates off", ^{
            beforeEach(^{
                 testManager.dynamicMenuUpdatesMode = SDLDynamicMenuUpdatesModeForceOff;
                 OCMStub([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
            });

            it(@"should send deletes first", ^{
                testManager.menuCells = @[textOnlyCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                testManager.menuCells = @[textAndImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                expect(deletes).to(haveCount(1));
                expect(adds).to(haveCount(2));
            });

            it(@"should deletes first case 2", ^{
                testManager.menuCells = @[textOnlyCell, textAndImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                testManager.menuCells = @[textAndImageCell, textOnlyCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                expect(deletes).to(haveCount(2));
                expect(adds).to(haveCount(4));
            });

            it(@"should send deletes first case 3", ^{
                testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *deleteSubCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteSubMenu class]];
                NSArray *subDeletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteSubCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
                NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];

                expect(deletes).to(haveCount(2));
                expect(subDeletes).to(haveCount(2));
                expect(adds).to(haveCount(9));
                expect(submenu).to(haveCount(3));
            });

            it(@"should send deletes first case 4", ^{
                testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, textOnlyCell2];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];


                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
                NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];

                NSPredicate *deleteSubCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteSubMenu class]];
                NSArray *subDeletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteSubCommandPredicate];

                expect(deletes).to(haveCount(2));
                expect(adds).to(haveCount(9));
                expect(submenu).to(haveCount(2));
                expect(subDeletes).to(haveCount(1));
            });

            it(@"should deletes first case 5", ^{
                testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                expect(deletes).to(haveCount(3));
                expect(adds).to(haveCount(6));
            });
        });
    });

    describe(@"running menu cell handlers", ^{
        __block SDLMenuCell *cellWithHandler = nil;
        __block BOOL cellCalled = NO;
        __block SDLTriggerSource testTriggerSource = nil;

        beforeEach(^{
            testManager.currentHMILevel = SDLHMILevelFull;
            testManager.currentSystemContext = SDLSystemContextMain;

            cellCalled = NO;
            testTriggerSource = nil;
        });

        context(@"on a main menu cell", ^{
            beforeEach(^{
                cellWithHandler = [[SDLMenuCell alloc] initWithTitle:@"Hello" icon:nil voiceCommands:nil secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
                    cellCalled = YES;
                    testTriggerSource = triggerSource;
                }];

                testManager.menuCells = @[cellWithHandler];
            });

            it(@"should call the cell handler", ^{
                SDLOnCommand *onCommand = [[SDLOnCommand alloc] init];
                onCommand.cmdID = @1;
                onCommand.triggerSource = SDLTriggerSourceMenu;

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveCommandNotification object:nil rpcNotification:onCommand];
                [[NSNotificationCenter defaultCenter] postNotification:notification];

                expect(cellCalled).to(beTrue());
                expect(testTriggerSource).to(equal(SDLTriggerSourceMenu));
            });
        });

        context(@"on a submenu menu cell", ^{
            beforeEach(^{
                cellWithHandler = [[SDLMenuCell alloc] initWithTitle:@"Hello" icon:nil voiceCommands:nil secondaryText:nil tertiaryText:nil secondaryArtwork:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
                    cellCalled = YES;
                    testTriggerSource = triggerSource;
                }];

                SDLMenuCell *submenuCell = [[SDLMenuCell alloc] initWithTitle:@"Submenu" icon:nil submenuLayout:SDLMenuLayoutTiles subCells:@[cellWithHandler] secondaryText:nil tertiaryText:nil secondaryArtwork:nil];

                testManager.menuCells = @[submenuCell];
            });

            it(@"should call the cell handler", ^{
                SDLOnCommand *onCommand = [[SDLOnCommand alloc] init];
                onCommand.cmdID = @2;
                onCommand.triggerSource = SDLTriggerSourceMenu;

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveCommandNotification object:nil rpcNotification:onCommand];
                [[NSNotificationCenter defaultCenter] postNotification:notification];

                expect(cellCalled).to(beTrue());
                expect(testTriggerSource).to(equal(SDLTriggerSourceMenu));
            });
        });
    });

    describe(@"updating the menu configuration", ^{
        beforeEach(^{
            testManager.currentHMILevel = SDLHMILevelFull;
            testManager.currentSystemContext = SDLSystemContextMain;
        });

        context(@"if the connection RPC version is less than 6.0.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"5.0.0"];
            });

            it(@"should fail to send a SetGlobalProperties RPC update", ^{
                testManager.menuConfiguration = testMenuConfiguration;

                expect(testManager.menuConfiguration).toNot(equal(testMenuConfiguration));
                expect(mockConnectionManager.receivedRequests).to(haveCount(0));
            });
        });

        context(@"if the connection RPC version is greater than or equal to 6.0.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"6.0.0"];
            });

            it(@"should send a SetGlobalProperties RPC update", ^{
                testManager.menuConfiguration = testMenuConfiguration;

                expect(testManager.menuConfiguration).to(equal(testMenuConfiguration));
                expect(mockConnectionManager.receivedRequests).to(haveCount(1));

                SDLSetGlobalPropertiesResponse *response = [[SDLSetGlobalPropertiesResponse alloc] init];
                response.success = @YES;
                [mockConnectionManager respondToLastRequestWithResponse:response];

                expect(testManager.menuConfiguration).to(equal(testMenuConfiguration));
            });
        });
    });

    context(@"when the manager stops", ^{
        beforeEach(^{
            [testManager stop];
        });

        it(@"should reset correctly", ^{
            expect(testManager.connectionManager).to(equal(mockConnectionManager));
            expect(testManager.fileManager).to(equal(mockFileManager));

            expect(testManager.menuCells).to(beEmpty());
            expect(testManager.currentHMILevel).to(beNil());
            expect(testManager.inProgressUpdate).to(beNil());
            expect(testManager.hasQueuedUpdate).to(beFalse());
            expect(testManager.waitingOnHMIUpdate).to(beFalse());
            expect(testManager.lastMenuId).to(equal(1));
            expect(testManager.oldMenuCells).to(beEmpty());
            expect(testManager.waitingUpdateMenuCells).to(beEmpty());
            expect(testManager.menuConfiguration).toNot(beNil());
        });
    });

    describe(@"ShowMenu RPC", ^{
        beforeEach(^{
            testManager.currentHMILevel = SDLHMILevelFull;
            testManager.currentSystemContext = SDLSystemContextMain;
        });

        context(@"when open menu RPC can be sent", ^{
            beforeEach(^{
                SDLVersion *oldVersion = [SDLVersion versionWithMajor:6 minor:0 patch:0];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(oldVersion);
            });

            it(@"should send showAppMenu RPC", ^{
                BOOL canSendRPC = [testManager openMenu];

                NSPredicate *showMenu = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLShowAppMenu class]];
                NSArray *openMenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:showMenu];

                expect(mockConnectionManager.receivedRequests).toNot(beEmpty());
                expect(openMenu).to(haveCount(1));
                expect(canSendRPC).to(equal(YES));
           });

            it(@"should send showAppMenu RPC with cellID", ^ {
                testManager.menuCells = @[submenuCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                BOOL canSendRPC = [testManager openSubmenu:submenuCell];

                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLShowAppMenu class]];
                NSArray *openMenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];

                expect(mockConnectionManager.receivedRequests).toNot(beEmpty());
                expect(openMenu).to(haveCount(1));
                expect(canSendRPC).to(equal(YES));
            });
        });

        context(@"when open menu RPC can not be sent", ^{
            it(@"should not send a showAppMenu RPC when cell has no subcells", ^ {
                BOOL canSendRPC = [testManager openSubmenu:textOnlyCell];

                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLShowAppMenu class]];
                NSArray *openMenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];

                expect(mockConnectionManager.receivedRequests).to(beEmpty());
                expect(openMenu).to(haveCount(0));
                expect(canSendRPC).to(equal(NO));
            });

            it(@"should not send a showAppMenu RPC when RPC verison is not at least 6.0.0", ^ {
                SDLVersion *oldVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(oldVersion);

                BOOL canSendRPC = [testManager openSubmenu:submenuCell];

                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLShowAppMenu class]];
                NSArray *openMenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];

                expect(mockConnectionManager.receivedRequests).to(beEmpty());
                expect(openMenu).to(haveCount(0));
                expect(canSendRPC).to(equal(NO));
            });

            it(@"should not send a showAppMenu RPC when the cell is not in the menu array", ^ {
                SDLVersion *oldVersion = [SDLVersion versionWithMajor:6 minor:0 patch:0];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(oldVersion);

                BOOL canSendRPC = [testManager openSubmenu:submenuCell];

                NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLShowAppMenu class]];
                NSArray *openMenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];

                expect(mockConnectionManager.receivedRequests).to(beEmpty());
                expect(openMenu).to(haveCount(0));
                expect(canSendRPC).to(equal(NO));
            });
        });
    });

    afterEach(^{
        testManager = nil;
    });
});

QuickSpecEnd
