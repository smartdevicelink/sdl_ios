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

SDLMenuParams* menu = [[SDLMenuParams alloc] init];
SDLImage* image = [[SDLImage alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAddCommand* testRequest = [[SDLAddCommand alloc] init];
        
        testRequest.cmdID = @434577;
        testRequest.menuParams = menu;
        testRequest.vrCommands = [@[@"name", @"anotherName"] mutableCopy];
        testRequest.cmdIcon = image;
        
        expect(testRequest.cmdID).to(equal(@434577));
        expect(testRequest.menuParams).to(equal(menu));
        expect(testRequest.vrCommands).to(equal([@[@"name", @"anotherName"] mutableCopy]));
        expect(testRequest.cmdIcon).to(equal(image));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                          @{SDLRPCParameterNameParameters:
                                                                @{SDLRPCParameterNameCommandId:@434577,
                                                                  SDLRPCParameterNameMenuParams:menu,
                                                                  SDLRPCParameterNameVRCommands:[@[@"name", @"anotherName"] mutableCopy],
                                                                  SDLRPCParameterNameCommandIcon:image},
                                                            SDLRPCParameterNameOperationName:SDLRPCFunctionNameAddCommand}} mutableCopy];
        SDLAddCommand* testRequest = [[SDLAddCommand alloc] initWithDictionary:dict];

        expect(testRequest.cmdID).to(equal(@434577));
        expect(testRequest.menuParams).to(equal(menu));
        expect(testRequest.vrCommands).to(equal([@[@"name", @"anotherName"] mutableCopy]));
        expect(testRequest.cmdIcon).to(equal(image));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAddCommand* testRequest = [[SDLAddCommand alloc] init];
        
        expect(testRequest.cmdID).to(beNil());
        expect(testRequest.menuParams).to(beNil());
        expect(testRequest.vrCommands).to(beNil());
        expect(testRequest.cmdIcon).to(beNil());
    });
});

describe(@"initializers", ^{
    __block SDLAddCommand *testCommand = nil;
    __block UInt32 commandId = 1234;
    __block NSArray<NSString *> *vrCommands = @[@"commands"];
    __block NSString *menuName = @"Menu Name";
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

    it(@"initWithCmdId:", ^{
        testCommand = [[SDLAddCommand alloc] initWithCmdID:commandId];

        expect(testCommand.cmdID).to(equal(commandId));
        expect(testCommand.vrCommands).to(beNil());
        expect(testCommand.menuParams).to(beNil());
        expect(testCommand.cmdIcon).to(beNil());
    });

    it(@"initWithCmdID:menuParams:vrCommands:", ^{
        testCommand = [[SDLAddCommand alloc] initWithCmdID:commandId menuParams:menu vrCommands:vrCommands cmdIcon:image];

        expect(testCommand.cmdID).to(equal(commandId));
        expect(testCommand.vrCommands).to(equal(vrCommands));
        expect(testCommand.menuParams).to(equal(menu));
        expect(testCommand.cmdIcon).to(equal(image));
    });

    context(@"initWithHandler:", ^{
        it(@"should initialize correctly", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCommand = [[SDLAddCommand alloc] initWithHandler:handler];
#pragma clang diagnostic pop

            expect(testCommand).toNot(beNil());
            expect(testCommand.vrCommands).to(beNil());
            expect(testCommand.menuParams).to(beNil());
            expect(testCommand.cmdIcon).to(beNil());
        });
    });

    context(@"initWithId:vrCommands:handler:", ^{
        it(@"should initialize correctly", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands handler:nil];
#pragma clang diagnostic pop

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams).to(beNil());
            expect(testCommand.cmdIcon).to(beNil());
        });
    });

    context(@"initWithId:vrCommands:menuName:handler:", ^{
        it(@"should initialize correctly", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands menuName:menuName handler:nil];
#pragma clang diagnostic pop

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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands menuName:menuName parentId:parentId position:position iconValue:iconValue iconType:imageType iconIsTemplate:imageIsTemplate handler:nil];
#pragma clang diagnostic pop

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams.menuName).toNot(beNil());
            expect(testCommand.menuParams.parentID).to(equal(parentId));
            expect(testCommand.menuParams.position).to(equal(position));

            expect(testCommand.cmdIcon).toNot(beNil());
            expect(testCommand.cmdIcon.valueParam).to(equal(iconValue));
            expect(testCommand.cmdIcon.imageType).to(equal(imageType));
            expect(testCommand.cmdIcon.isTemplate).to(equal(imageIsTemplate));
        });

        it(@"should initialize without an image", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands menuName:menuName parentId:parentId position:position iconValue:nil iconType:nil iconIsTemplate:NO handler:nil];
#pragma clang diagnostic pop

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
            SDLImage *image = [[SDLImage alloc] initWithValueParam:@"Icon" imageType:SDLImageTypeDynamic isTemplate:@YES];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands menuName:menuName parentId:parentId position:position icon:image handler:nil];
#pragma clang diagnostic pop

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams.menuName).toNot(beNil());
            expect(testCommand.menuParams.parentID).to(equal(parentId));
            expect(testCommand.menuParams.position).to(equal(position));

            expect(testCommand.cmdIcon).toNot(beNil());
            expect(testCommand.cmdIcon.valueParam).to(equal(image.valueParam));
            expect(testCommand.cmdIcon.imageType).to(equal(image.imageType));
            expect(testCommand.cmdIcon.isTemplate).to(equal(image.isTemplate));
        });

        it(@"should initialize without an image", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:vrCommands menuName:menuName parentId:parentId position:position icon:nil handler:nil];
#pragma clang diagnostic pop

            expect(testCommand.cmdID).to(equal(commandId));
            expect(testCommand.vrCommands).to(equal(vrCommands));
            expect(testCommand.menuParams.menuName).toNot(beNil());
            expect(testCommand.menuParams.parentID).to(equal(parentId));
            expect(testCommand.menuParams.position).to(equal(position));

            expect(testCommand.cmdIcon).to(beNil());
        });
    });
});

QuickSpecEnd
