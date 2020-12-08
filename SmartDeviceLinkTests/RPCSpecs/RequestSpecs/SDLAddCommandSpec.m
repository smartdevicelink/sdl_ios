//
//  SDLAddCommandSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLImage.h"
#import "SDLMenuParams.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLAddCommandSpec)

describe(@"Getter/Setter Tests", ^ {
    SDLMenuParams* menu = [[SDLMenuParams alloc] init];
    SDLImage *image = [[SDLImage alloc] initWithName:@"Icon" ofType:SDLImageTypeDynamic isTemplate:YES];
    SDLImage *testSecondaryImage = [[SDLImage alloc] initWithStaticIconName:SDLStaticIconNameKey];

    it(@"Should set and get correctly", ^ {
        SDLAddCommand* testRequest = [[SDLAddCommand alloc] init];
        
        testRequest.cmdID = @434577;
        testRequest.menuParams = menu;
        testRequest.vrCommands = [@[@"name", @"anotherName"] mutableCopy];
        testRequest.cmdIcon = image;
        testRequest.secondaryImage = testSecondaryImage;
        
        expect(testRequest.cmdID).to(equal(@434577));
        expect(testRequest.menuParams).to(equal(menu));
        expect(testRequest.vrCommands).to(equal([@[@"name", @"anotherName"] mutableCopy]));
        expect(testRequest.cmdIcon).to(equal(image));
        expect(testRequest.secondaryImage).to(equal(testSecondaryImage));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                          @{SDLRPCParameterNameParameters:
                                                                @{SDLRPCParameterNameCommandId:@434577,
                                                                  SDLRPCParameterNameMenuParams:menu,
                                                                  SDLRPCParameterNameVRCommands:[@[@"name", @"anotherName"] mutableCopy],
                                                                  SDLRPCParameterNameCommandIcon:image,
                                                                  SDLRPCParameterNameSecondaryImage: testSecondaryImage},
                                                                  SDLRPCParameterNameOperationName:SDLRPCFunctionNameAddCommand}} mutableCopy];
        SDLAddCommand* testRequest = [[SDLAddCommand alloc] initWithDictionary:dict];

        expect(testRequest.cmdID).to(equal(@434577));
        expect(testRequest.menuParams).to(equal(menu));
        expect(testRequest.vrCommands).to(equal([@[@"name", @"anotherName"] mutableCopy]));
        expect(testRequest.cmdIcon).to(equal(image));
        expect(testRequest.secondaryImage).to(equal(testSecondaryImage));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAddCommand* testRequest = [[SDLAddCommand alloc] init];
        
        expect(testRequest.cmdID).to(beNil());
        expect(testRequest.menuParams).to(beNil());
        expect(testRequest.vrCommands).to(beNil());
        expect(testRequest.cmdIcon).to(beNil());
        expect(testRequest.secondaryImage).to(beNil());
    });
});

describe(@"initializers", ^{
    __block SDLAddCommand *testCommand = nil;
    __block UInt32 commandId = 1234;
    __block NSArray<NSString *> *vrCommands = @[@"commands"];
    __block NSString *menuName = @"Menu Name";
    SDLImage *image = [[SDLImage alloc] initWithName:@"Icon" ofType:SDLImageTypeDynamic isTemplate:YES];
    SDLImage *testSecondaryImage = [[SDLImage alloc] initWithStaticIconName:SDLStaticIconNameKey];
    SDLMenuParams *testMenuParams = [[SDLMenuParams alloc] initWithMenuName:menuName];
    void (^handler)(SDLOnCommand *) = ^(SDLOnCommand *command) {};

    beforeEach(^{
        testCommand = nil;
    });

    context(@"init", ^{
        testCommand = [[SDLAddCommand alloc] init];

        expect(testCommand).toNot(beNil());
        expect(testCommand.cmdID).to(beNil());
        expect(testCommand.vrCommands).to(beNil());
        expect(testCommand.menuParams).to(beNil());
        expect(testCommand.cmdIcon).to(beNil());
    });

    context(@"initWithHandler:", ^{
        it(@"should initialize correctly", ^{
            testCommand = [[SDLAddCommand alloc] initWithHandler:handler];

            expect(testCommand).toNot(beNil());
            expect(testCommand.vrCommands).to(beNil());
            expect(testCommand.menuParams).to(beNil());
            expect(testCommand.cmdIcon).to(beNil());
        });
    });

    context(@"initWithId:vrCommands:handler:", ^{
        it(@"should initialize correctly", ^{
            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands handler:nil];

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams).to(beNil());
            expect(testCommand.cmdIcon).to(beNil());
        });
    });

    context(@"initWithId:vrCommands:menuName:handler:", ^{
        it(@"should initialize correctly", ^{
            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands menuName:menuName handler:nil];

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams).toNot(beNil());
            expect(testCommand.cmdIcon).to(beNil());
        });
    });

    context(@"initWithId:vrCommands:menuName:parentId:position:iconValue:iconType:iconIsTemplate:handler:", ^{
        __block UInt32 parentId = 12345;
        __block UInt16 position = 0;

        it(@"should initialize with an image", ^{
            NSString *iconValue = @"Icon";
            SDLImageType imageType = SDLImageTypeDynamic;
            BOOL imageIsTemplate = YES;

            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands menuName:menuName parentId:parentId position:position iconValue:iconValue iconType:imageType iconIsTemplate:imageIsTemplate handler:nil];

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams.menuName).toNot(beNil());
            expect(testCommand.menuParams.parentID).to(equal(parentId));
            expect(testCommand.menuParams.position).to(equal(position));

            expect(testCommand.cmdIcon).toNot(beNil());
            expect(testCommand.cmdIcon.value).to(equal(iconValue));
            expect(testCommand.cmdIcon.imageType).to(equal(imageType));
            expect(testCommand.cmdIcon.isTemplate).to(equal(imageIsTemplate));
        });

        it(@"should initialize without an image", ^{
            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands menuName:menuName parentId:parentId position:position iconValue:nil iconType:nil iconIsTemplate:NO handler:nil];

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams.menuName).toNot(beNil());
            expect(testCommand.menuParams.parentID).to(equal(parentId));
            expect(testCommand.menuParams.position).to(equal(position));
            expect(testCommand.cmdIcon).to(beNil());
        });
    });

    context(@"initWithId:vrCommands:menuName:parentId:position:icon:handler:", ^{
        __block UInt32 parentId = 365;
        __block UInt16 position = 0;

        it(@"should initialize with an image", ^{
            SDLImage *image = [[SDLImage alloc] initWithName:@"Icon" ofType:SDLImageTypeDynamic isTemplate:YES];

            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands menuName:menuName parentId:parentId position:position icon:image handler:nil];

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams.menuName).toNot(beNil());
            expect(testCommand.menuParams.parentID).to(equal(parentId));
            expect(testCommand.menuParams.position).to(equal(position));

            expect(testCommand.cmdIcon).toNot(beNil());
            expect(testCommand.cmdIcon.value).to(equal(image.value));
            expect(testCommand.cmdIcon.imageType).to(equal(image.imageType));
            expect(testCommand.cmdIcon.isTemplate).to(equal(image.isTemplate));
        });

        it(@"should initialize without an image", ^{
            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands menuName:menuName parentId:parentId position:position icon:nil handler:nil];

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams.menuName).toNot(beNil());
            expect(testCommand.menuParams.parentID).to(equal(parentId));
            expect(testCommand.menuParams.position).to(equal(position));

            expect(testCommand.cmdIcon).to(beNil());
        });
    });

    context(@"- (instancetype)initWithCmdID:menuParams:vrCommands:cmdIcon:secondaryImage", ^{
        it(@"should initialize with an image", ^{
            testCommand = [[SDLAddCommand alloc] initWithCmdID:commandId menuParams:testMenuParams vrCommands:vrCommands cmdIcon:image secondaryImage:testSecondaryImage handler: nil];

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams).to(equal(testMenuParams));

            expect(testCommand.cmdIcon).toNot(beNil());
            expect(testCommand.cmdIcon.value).to(equal(image.value));
            expect(testCommand.cmdIcon.imageType).to(equal(image.imageType));
            expect(testCommand.cmdIcon.isTemplate).to(equal(image.isTemplate));

            expect(testCommand.secondaryImage).toNot(beNil());
            expect(testCommand.secondaryImage.value).to(equal(testSecondaryImage.value));
            expect(testCommand.secondaryImage.imageType).to(equal(testSecondaryImage.imageType));
            expect(testCommand.secondaryImage.isTemplate).to(equal(testSecondaryImage.isTemplate));
        });

        it(@"should initialize without an image", ^{
            testCommand = [[SDLAddCommand alloc] initWithCmdID:commandId menuParams:testMenuParams vrCommands:vrCommands cmdIcon:image secondaryImage:nil handler:nil];

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams).to(equal(testMenuParams));

            expect(testCommand.cmdIcon).toNot(beNil());
            expect(testCommand.cmdIcon.value).to(equal(image.value));
            expect(testCommand.cmdIcon.imageType).to(equal(image.imageType));
            expect(testCommand.cmdIcon.isTemplate).to(equal(image.isTemplate));

            expect(testCommand.secondaryImage).to(beNil());
        });
    });
});

QuickSpecEnd
