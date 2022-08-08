#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import <SmartDeviceLink/SmartDeviceLink.h>

#import "SDLGlobals.h"
#import "SDLMenuManager.h"
#import "SDLMenuShowOperation.h"
#import "SDLMenuReplaceOperation.h"
#import "TestConnectionManager.h"


@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;

@end

@interface SDLMenuShowOperation()

@property (strong, nonatomic, nullable) SDLMenuCell *submenuCell;

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

@end

QuickSpecBegin(SDLMenuManagerSpec)

describe(@"menu manager", ^{
    __block SDLMenuManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = nil;
    __block SDLFileManager *mockFileManager = nil;
    __block SDLSystemCapabilityManager *mockSystemCapabilityManager = nil;

    __block SDLMenuConfiguration *testMenuConfiguration = nil;

    __block SDLMenuCell *textOnlyCell = nil;
    __block SDLMenuCell *submenuCell = nil;

    beforeEach(^{
        textOnlyCell = [[SDLMenuCell alloc] initWithTitle:@"Test 1" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        submenuCell = [[SDLMenuCell alloc] initWithTitle:@"Test 3" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil submenuLayout:nil subCells:@[textOnlyCell]];

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
    });

    describe(@"when the manager stops", ^{
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
        });
    });

    context(@"when in HMI NONE", ^{
        beforeEach(^{
            SDLOnHMIStatus *noneStatus = [[SDLOnHMIStatus alloc] initWithHMILevel:SDLHMILevelNone systemContext:SDLSystemContextMain audioStreamingState:SDLAudioStreamingStateNotAudible videoStreamingState:nil windowID:nil];
            [[NSNotificationCenter defaultCenter] postNotification:[[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:noneStatus]];
        });

        it(@"should not suspend the transaction queue", ^{
            expect(testManager.transactionQueue.isSuspended).to(beTrue());
        });

        // when entering HMI FULL
        describe(@"when entering HMI FULL", ^{
            beforeEach(^{
                SDLOnHMIStatus *onHMIStatus = [[SDLOnHMIStatus alloc] init];
                onHMIStatus.hmiLevel = SDLHMILevelFull;
                onHMIStatus.systemContext = SDLSystemContextMain;

                SDLRPCNotificationNotification *testSystemContextNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:onHMIStatus];
                [[NSNotificationCenter defaultCenter] postNotification:testSystemContextNotification];
            });

            it(@"should run the transaction queue", ^{
                expect(testManager.transactionQueue.isSuspended).to(beFalse());
            });
        });
    });

    context(@"when the HMI is ready", ^{
        beforeEach(^{
            testManager.currentHMILevel = SDLHMILevelFull;
            testManager.currentSystemContext = SDLSystemContextMain;
        });

        describe(@"setting new menu cells", ^{
            context(@"containing duplicate titles", ^{
                it(@"should not start an operation", ^{
                    testManager.menuCells = @[textOnlyCell, textOnlyCell];
                    expect(testManager.menuCells).to(beEmpty());
                    expect(testManager.transactionQueue.operationCount).to(equal(0));
                });
            });

            context(@"containing duplicate VR commands", ^{
                SDLMenuCell *textAndVRCell1 = [[SDLMenuCell alloc] initWithTitle:@"Test 1" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:@[@"Cat", @"Turtle"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
                SDLMenuCell *textAndVRCell2 = [[SDLMenuCell alloc] initWithTitle:@"Test 3" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:@[@"Cat", @"Dog"] handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

                it(@"should not start an operation", ^{
                    testManager.menuCells = @[textAndVRCell1, textAndVRCell2];
                    expect(testManager.menuCells).to(beEmpty());
                    expect(testManager.transactionQueue.operationCount).to(equal(0));
                });
            });

            context(@"if the new menu cells are identical to the old menu cells", ^{
                it(@"should queue two transactions and let the operation handle not updating", ^{
                    testManager.menuCells = @[textOnlyCell];
                    testManager.menuCells = @[textOnlyCell];

                    expect(testManager.menuCells).to(equal(@[textOnlyCell]));
                    expect(testManager.transactionQueue.operationCount).to(equal(2));
                });
            });

            context(@"when a second menu cells update is queued before the first is done", ^{
                it(@"should cancel the first operation", ^{
                    testManager.menuCells = @[textOnlyCell];
                    testManager.menuCells = @[submenuCell];

                    expect(testManager.menuCells).to(equal(@[submenuCell]));
                    expect(testManager.transactionQueue.operationCount).to(equal(2));
                    expect(testManager.transactionQueue.operations[0].isCancelled).to(beTrue());
                });
            });

            context(@"if cells are formed properly", ^{
                it(@"should properly prepare and queue the transaction", ^{
                    testManager.menuCells = @[textOnlyCell];

                    expect(testManager.transactionQueue.operationCount).to(equal(1));
                    expect(testManager.transactionQueue.operations[0]).to(beAnInstanceOf([SDLMenuReplaceOperation class]));

                    // Assign proper current menu
                    SDLMenuReplaceOperation *testOp = testManager.transactionQueue.operations[0];
                    expect(testOp.currentMenu).to(haveCount(0));

                    // Callback proper current menu
                    testOp.currentMenu = @[textOnlyCell];
                    [testOp finishOperation];
                    expect(testManager.currentMenuCells).to(haveCount(1));
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

                it(@"should not queue a menu configuration update", ^{
                    testManager.menuConfiguration = testMenuConfiguration;

                    expect(testManager.menuConfiguration).toNot(equal(testMenuConfiguration));
                    expect(testManager.transactionQueue.operationCount).to(equal(0));
                });
            });

            context(@"if the connection RPC version is greater than or equal to 6.0.0", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"6.0.0"];
                });

                it(@"should should queue a menu configuration update", ^{
                    testManager.menuConfiguration = testMenuConfiguration;

                    expect(testManager.menuConfiguration).to(equal(testMenuConfiguration));
                    expect(testManager.transactionQueue.operationCount).to(equal(1));
                });

                context(@"when queueing a second task after the first", ^{
                    it(@"should cancel the first task", ^{
                        testManager.menuConfiguration = testMenuConfiguration;
                        testManager.menuConfiguration = [[SDLMenuConfiguration alloc] initWithMainMenuLayout:SDLMenuLayoutList defaultSubmenuLayout:SDLMenuLayoutList];

                        expect(testManager.transactionQueue.operationCount).to(equal(2));
                        expect(testManager.transactionQueue.operations[0].isCancelled).to(beTrue());
                    });
                });
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

                // should queue an open menu operation for the main menu
                it(@"should queue an open menu operation for the main menu", ^{
                    BOOL canSendRPC = [testManager openMenu:nil];

                    expect(testManager.transactionQueue.operationCount).to(equal(1));
                    expect(canSendRPC).to(equal(YES));
                });

                // should queue an open menu operation for a submenu cell
                it(@"should queue an open menu operation for a submenu cell", ^ {
                    testManager.menuCells = @[submenuCell];
                    BOOL canSendRPC = [testManager openMenu:submenuCell];

                    expect(testManager.transactionQueue.operationCount).to(equal(2));
                    expect(canSendRPC).to(equal(YES));
                });

                // should queue an open menu operation for a copied submenu cell
                it(@"should queue an open menu operation for a copied submenu cell and match the original cell id", ^ {
                    submenuCell.cellId = 1;
                    testManager.menuCells = @[submenuCell];

                    SDLMenuCell *copiedCell = [[SDLMenuCell alloc] initWithTitle:@"Test 3" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil submenuLayout:nil subCells:@[textOnlyCell]];
                    
                    BOOL canSendRPC = [testManager openMenu:copiedCell];
                    SDLMenuShowOperation *showOperation = (SDLMenuShowOperation *)testManager.transactionQueue.operations[1];

                    expect(showOperation.submenuCell.cellId).to(equal(submenuCell.cellId));
                    expect(showOperation.submenuCell.cellId).toNot(equal(copiedCell.cellId));
                    expect(testManager.transactionQueue.operationCount).to(equal(2));
                    expect(canSendRPC).to(equal(YES));
                });

                it(@"should cancel the first task if a second is queued", ^{
                    testManager.menuCells = @[submenuCell];
                    [testManager openMenu:nil];
                    [testManager openMenu:submenuCell];

                    expect(testManager.transactionQueue.operationCount).to(equal(3));
                    expect(testManager.transactionQueue.operations[1].isCancelled).to(beTrue());
                });
            });

            context(@"when the open menu RPC can not be sent", ^{
                it(@"should not queue an open menu operation when cell has no subcells", ^ {
                    BOOL canSendRPC = [testManager openMenu:textOnlyCell];

                    expect(testManager.transactionQueue.operationCount).to(equal(0));
                    expect(canSendRPC).to(equal(NO));
                });

                it(@"should not queue an open menu operation when RPC version is not at least 6.0.0", ^ {
                    SDLVersion *oldVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
                    id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                    OCMStub([globalMock rpcVersion]).andReturn(oldVersion);

                    BOOL canSendRPC = [testManager openMenu:submenuCell];

                    expect(testManager.transactionQueue.operationCount).to(equal(0));
                    expect(canSendRPC).to(equal(NO));
                });

                it(@"should not queue an open menu operation when the cell is not in the menu array", ^ {
                    SDLVersion *oldVersion = [SDLVersion versionWithMajor:6 minor:0 patch:0];
                    id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                    OCMStub([globalMock rpcVersion]).andReturn(oldVersion);

                    BOOL canSendRPC = [testManager openMenu:submenuCell];

                    expect(testManager.transactionQueue.operationCount).to(equal(0));
                    expect(canSendRPC).to(equal(NO));
                });
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
                cellWithHandler = [[SDLMenuCell alloc] initWithTitle:@"Hello" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
                    cellCalled = YES;
                    testTriggerSource = triggerSource;
                }];
                cellWithHandler.cellId = 1;

                testManager.currentMenuCells = @[cellWithHandler];
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
                cellWithHandler = [[SDLMenuCell alloc] initWithTitle:@"Hello" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
                    cellCalled = YES;
                    testTriggerSource = triggerSource;
                }];
                cellWithHandler.cellId = 2;

                SDLMenuCell *submenuCell = [[SDLMenuCell alloc] initWithTitle:@"Submenu" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil submenuLayout:SDLMenuLayoutTiles subCells:@[cellWithHandler]];
                submenuCell.cellId = 1;

                cellWithHandler.parentCellId = 1;

                testManager.currentMenuCells = @[submenuCell];
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
});

QuickSpecEnd
