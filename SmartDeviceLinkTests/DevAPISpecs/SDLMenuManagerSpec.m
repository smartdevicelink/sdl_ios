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

@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (strong, nonatomic, nullable) SDLWindowCapability *windowCapability;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *currentMenuCells;
@property (strong, nonatomic, nullable) SDLMenuConfiguration *currentMenuConfiguration;

@property (assign, nonatomic) UInt32 lastMenuId;

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
    __block SDLMenuCell *submenuCell = nil;
    __block SDLMenuCell *submenuImageCell = nil;

    __block SDLMenuConfiguration *testMenuConfiguration = nil;

    beforeEach(^{
        testArtwork = [[SDLArtwork alloc] initWithData:[@"Test data" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name" fileExtension:@"png" persistent:NO];
        testArtwork2 = [[SDLArtwork alloc] initWithData:[@"Test data 2" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name 2" fileExtension:@"png" persistent:NO];
        testArtwork3 = [[SDLArtwork alloc] initWithData:[@"Test data 3" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name" fileExtension:@"png" persistent:NO];
        testArtwork3.overwrite = YES;

        textOnlyCell = [[SDLMenuCell alloc] initWithTitle:@"Test 1" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:testArtwork voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        submenuCell = [[SDLMenuCell alloc] initWithTitle:@"Test 3" icon:nil submenuLayout:nil subCells:@[textOnlyCell, textAndImageCell]];
        submenuImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 4" icon:testArtwork2 submenuLayout:SDLMenuLayoutTiles subCells:@[textOnlyCell]];
        textOnlyCell2 = [[SDLMenuCell alloc] initWithTitle:@"Test 5" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

        testMenuConfiguration = [[SDLMenuConfiguration alloc] initWithMainMenuLayout:SDLMenuLayoutTiles defaultSubmenuLayout:SDLMenuLayoutList];


        mockConnectionManager = [[TestConnectionManager alloc] init];
        mockFileManager = OCMClassMock([SDLFileManager class]);
        mockSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);
        testManager = [[SDLMenuManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager];

        SDLImageField *commandIconField = [[SDLImageField alloc] init];
        commandIconField.name = SDLImageFieldNameCommandIcon;
        SDLWindowCapability *windowCapability = [[SDLWindowCapability alloc] init];
        windowCapability.windowID = @(SDLPredefinedWindowsDefaultWindow);
        windowCapability.imageFields = @[commandIconField];
        windowCapability.imageTypeSupported = @[SDLImageTypeDynamic, SDLImageTypeStatic];
        windowCapability.menuLayoutsAvailable = @[SDLMenuLayoutList, SDLMenuLayoutTiles];
        testManager.windowCapability = windowCapability;
    });

    it(@"should instantiate correctly", ^{
        expect(testManager.menuCells).to(beEmpty());

        expect(@(testManager.dynamicMenuUpdatesMode)).to(equal(@(SDLDynamicMenuUpdatesModeOnWithCompatibility)));
        expect(testManager.connectionManager).to(equal(mockConnectionManager));
        expect(testManager.fileManager).to(equal(mockFileManager));
        expect(testManager.systemCapabilityManager).to(equal(mockSystemCapabilityManager));
        expect(testManager.transactionQueue).toNot(beNil());
        expect(testManager.windowCapability).toNot(beNil());
        expect(testManager.currentHMILevel).to(beNil());
        expect(testManager.currentSystemContext).to(beNil());
        expect(testManager.currentMenuCells).to(beEmpty());
        expect(testManager.currentMenuConfiguration).to(beNil());
        expect(testManager.lastMenuId).to(equal(1));
    });

    describe(@"updating menu cells before HMI is ready", ^{
        context(@"when in HMI NONE", ^{
            beforeEach(^{
                testManager.currentHMILevel = SDLHMILevelNone;
                testManager.menuCells = @[textOnlyCell];
            });

            it(@"should not update", ^{
                expect(testManager.transactionQueue.isSuspended).to(beTrue());
                expect(testManager.transactionQueue.operationCount).to(equal(1));
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
                    expect(testManager.transactionQueue.operationCount).to(equal(1));
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

            it(@"should not open the menu", ^{

            });

            it(@"should not update the menu cells", ^{
                testManager.menuCells = @[textOnlyCell];
                expect(mockConnectionManager.receivedRequests).to(beEmpty());
            });
        });
    });

    describe(@"updating menu cells", ^{
        beforeEach(^{
            testManager.currentHMILevel = SDLHMILevelFull;
            testManager.currentSystemContext = SDLSystemContextMain;
        });

        context(@"duplicate titles", ^{
            it(@"should fail with a duplicate title", ^{
                testManager.menuCells = @[textOnlyCell, textOnlyCell];
                expect(testManager.menuCells).to(beEmpty());
            });
        });

        context(@"duplicate VR commands", ^{
            __block SDLMenuCell *textAndVRCell1 = [[SDLMenuCell alloc] initWithTitle:@"Test 1" icon:nil voiceCommands:@[@"Cat", @"Turtle"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            __block SDLMenuCell *textAndVRCell2 = [[SDLMenuCell alloc] initWithTitle:@"Test 3" icon:nil voiceCommands:@[@"Cat", @"Dog"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

            it(@"should fail when menu items have duplicate vr commands", ^{
                testManager.menuCells = @[textAndVRCell1, textAndVRCell2];
                expect(testManager.menuCells).to(beEmpty());
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
                cellWithHandler = [[SDLMenuCell alloc] initWithTitle:@"Hello" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
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
                cellWithHandler = [[SDLMenuCell alloc] initWithTitle:@"Hello" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
                    cellCalled = YES;
                    testTriggerSource = triggerSource;
                }];

                SDLMenuCell *submenuCell = [[SDLMenuCell alloc] initWithTitle:@"Submenu" icon:nil submenuLayout:SDLMenuLayoutTiles subCells:@[cellWithHandler]];

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
                expect(testManager.transactionQueue.operationCount).to(equal(0));
            });
        });

        context(@"if the connection RPC version is greater than or equal to 6.0.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"6.0.0"];
            });

            it(@"should send a SetGlobalProperties RPC update", ^{
                testManager.menuConfiguration = testMenuConfiguration;

                expect(testManager.menuConfiguration).to(equal(testMenuConfiguration));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
            });
        });

        context(@"when no HMI level has been received", ^{
            beforeEach(^{
                testManager.currentHMILevel = nil;
            });

            it(@"should queue the update to the menu configuration", ^{
                testManager.menuConfiguration = testMenuConfiguration;

                expect(testManager.menuConfiguration).to(equal(testMenuConfiguration));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
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
                expect(testManager.menuConfiguration).to(equal(testMenuConfiguration));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
            });
        });
    });

    context(@"when the manager stops", ^{
        beforeEach(^{
            [testManager stop];
        });

        it(@"should reset correctly", ^{
            expect(testManager.menuCells).to(beEmpty());

            expect(@(testManager.dynamicMenuUpdatesMode)).to(equal(@(SDLDynamicMenuUpdatesModeOnWithCompatibility)));
            expect(testManager.connectionManager).to(equal(mockConnectionManager));
            expect(testManager.fileManager).to(equal(mockFileManager));
            expect(testManager.systemCapabilityManager).to(equal(mockSystemCapabilityManager));
            expect(testManager.transactionQueue).toNot(beNil());
            expect(testManager.windowCapability).to(beNil());
            expect(testManager.currentHMILevel).to(beNil());
            expect(testManager.currentSystemContext).to(beNil());
            expect(testManager.currentMenuCells).to(beEmpty());
            expect(testManager.currentMenuConfiguration).to(beNil());
            expect(testManager.lastMenuId).to(equal(1));
        });
    });

    describe(@"opening the menu", ^{
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
                BOOL canSendRPC = [testManager openMenu:nil];

                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(canSendRPC).to(equal(YES));
           });

            it(@"should send showAppMenu RPC with cellID", ^ {
                testManager.menuCells = @[submenuCell];
                BOOL canSendRPC = [testManager openMenu:submenuCell];

                expect(testManager.transactionQueue.operationCount).to(equal(2));
                expect(canSendRPC).to(equal(YES));
            });
        });

        context(@"when open menu RPC can not be sent", ^{
            it(@"should not send a showAppMenu RPC when cell has no subcells", ^ {
                BOOL canSendRPC = [testManager openMenu:textOnlyCell];

                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(canSendRPC).to(equal(NO));
            });

            it(@"should not send a showAppMenu RPC when RPC verison is not at least 6.0.0", ^ {
                SDLVersion *oldVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(oldVersion);

                BOOL canSendRPC = [testManager openMenu:submenuCell];

                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(canSendRPC).to(equal(NO));
            });

            it(@"should not send a showAppMenu RPC when the cell is not in the menu array", ^ {
                SDLVersion *oldVersion = [SDLVersion versionWithMajor:6 minor:0 patch:0];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(oldVersion);

                BOOL canSendRPC = [testManager openMenu:submenuCell];

                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(canSendRPC).to(equal(NO));
            });
        });
    });

    afterEach(^{
        testManager = nil;
    });
});

QuickSpecEnd
