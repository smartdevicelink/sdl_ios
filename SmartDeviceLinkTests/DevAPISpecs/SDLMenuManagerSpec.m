#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLAddCommand.h"
#import "SDLAddSubMenu.h"
#import "SDLDeleteCommand.h"
#import "SDLDisplayCapabilities.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLImage.h"
#import "SDLImageField.h"
#import "SDLImageFieldName.h"
#import "SDLMenuCell.h"
#import "SDLMenuManager.h"
#import "SDLOnCommand.h"
#import "SDLOnHMIStatus.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSystemContext.h"
#import "TestConnectionManager.h"

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;

@end

@interface SDLMenuManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;
@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@property (strong, nonatomic, nullable) NSArray<SDLRPCRequest *> *inProgressUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (assign, nonatomic) BOOL waitingOnHMIUpdate;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *waitingUpdateMenuCells;

@property (assign, nonatomic) UInt32 lastMenuId;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *oldMenuCells;

@end

QuickSpecBegin(SDLMenuManagerSpec)

describe(@"menu manager", ^{
    __block SDLMenuManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = nil;
    __block SDLFileManager *mockFileManager = nil;

    __block SDLArtwork *testArtwork = nil;
    __block SDLArtwork *testArtwork2 = nil;

    __block SDLMenuCell *textOnlyCell = nil;
    __block SDLMenuCell *textAndImageCell = nil;
    __block SDLMenuCell *submenuCell = nil;
    __block SDLMenuCell *submenuImageCell = nil;

    beforeEach(^{
        testArtwork = [[SDLArtwork alloc] initWithData:[@"Test data" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name" fileExtension:@"png" persistent:NO];
        testArtwork2 = [[SDLArtwork alloc] initWithData:[@"Test data 2" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name 2" fileExtension:@"png" persistent:NO];

        textOnlyCell = [[SDLMenuCell alloc] initWithTitle:@"Test 1" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" icon:testArtwork voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        submenuCell = [[SDLMenuCell alloc] initWithTitle:@"Test 3" icon:nil subCells:@[textOnlyCell, textAndImageCell]];
        submenuImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 4" icon:testArtwork2 subCells:@[textOnlyCell]];

        mockConnectionManager = [[TestConnectionManager alloc] init];
        mockFileManager = OCMClassMock([SDLFileManager class]);
        testManager = [[SDLMenuManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager];
    });

    it(@"should instantiate correctly", ^{
        expect(testManager.menuCells).to(beEmpty());
        expect(testManager.connectionManager).to(equal(mockConnectionManager));
        expect(testManager.fileManager).to(equal(mockFileManager));
        expect(testManager.currentHMILevel).to(beNil());
        expect(testManager.displayCapabilities).to(beNil());
        expect(testManager.inProgressUpdate).to(beNil());
        expect(testManager.hasQueuedUpdate).to(beFalse());
        expect(testManager.waitingOnHMIUpdate).to(beFalse());
        expect(testManager.lastMenuId).to(equal(1));
        expect(testManager.oldMenuCells).to(beEmpty());
        expect(testManager.waitingUpdateMenuCells).to(beNil());
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
                testManager.menuCells = @[textOnlyCell];
            });

            it(@"should not update", ^{
                expect(mockConnectionManager.receivedRequests).to(beEmpty());
            });
        });

        context(@"when in the menu", ^{
            beforeEach(^{
                testManager.currentHMILevel = SDLHMILevelFull;
                testManager.currentSystemContext = SDLSystemContextMenu;
                testManager.menuCells = @[textOnlyCell];
            });

            it(@"should not update", ^{
                expect(mockConnectionManager.receivedRequests).to(beEmpty());
            });

            describe(@"when exiting the menu", ^{
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
    });

    describe(@"updating menu cells", ^{
        beforeEach(^{
            testManager.currentHMILevel = SDLHMILevelFull;
            testManager.currentSystemContext = SDLSystemContextMain;

            testManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
            SDLImageField *commandIconField = [[SDLImageField alloc] init];
            commandIconField.name = SDLImageFieldNameCommandIcon;
            testManager.displayCapabilities.imageFields = @[commandIconField];
            testManager.displayCapabilities.graphicSupported = @YES;
        });

        it(@"should fail with a duplicate title", ^{
            testManager.menuCells = @[textOnlyCell, textOnlyCell];

            expect(testManager.menuCells).to(beEmpty());
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
                });
            });

            context(@"when the image is not on the head unit", ^{
                beforeEach(^{
                    OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);
                });

                it(@"should immediately attempt to update without the image", ^{
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

        describe(@"updating when a menu already exists", ^{
            beforeEach(^{
                testManager.menuCells = @[textOnlyCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES]; // Adds
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES]; // Submenu

                testManager.menuCells = @[textAndImageCell];
                [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES]; // Deletes
            });

            it(@"should send deletes first", ^{
                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                expect(deletes).to(haveCount(1));
                expect(adds).to(haveCount(2));
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

            testManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
            SDLImageField *commandIconField = [[SDLImageField alloc] init];
            commandIconField.name = SDLImageFieldNameCommandIcon;
            testManager.displayCapabilities.imageFields = @[commandIconField];
            testManager.displayCapabilities.graphicSupported = @YES;

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

                SDLMenuCell *submenuCell = [[SDLMenuCell alloc] initWithTitle:@"Submenu" icon:nil subCells:@[cellWithHandler]];

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

    context(@"On disconnects", ^{
        beforeEach(^{
            [testManager stop];
        });

        it(@"should reset correctly", ^{
            expect(testManager.connectionManager).to(equal(mockConnectionManager));
            expect(testManager.fileManager).to(equal(mockFileManager));

            expect(testManager.menuCells).to(beEmpty());
            expect(testManager.currentHMILevel).to(beNil());
            expect(testManager.displayCapabilities).to(beNil());
            expect(testManager.inProgressUpdate).to(beNil());
            expect(testManager.hasQueuedUpdate).to(beFalse());
            expect(testManager.waitingOnHMIUpdate).to(beFalse());
            expect(testManager.lastMenuId).to(equal(1));
            expect(testManager.oldMenuCells).to(beEmpty());
            expect(testManager.waitingUpdateMenuCells).to(beEmpty());
        });
    });

    afterEach(^{
        testManager = nil;
    });
});

QuickSpecEnd
