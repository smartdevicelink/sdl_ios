//
//  SDLMenuParamsSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMenuParams.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLMenuParamsSpec)

describe(@"Initialization tests", ^{
    __block UInt32 testParentId = 504320489;
    __block UInt16 testPosition = testPosition;
    __block NSString *testMenuName = @"Test Menu";

    it(@"should properly initialize init", ^{
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] init];

        expect(testStruct.parentID).to(beNil());
        expect(testStruct.position).to(beNil());
        expect(testStruct.menuName).to(beNil());
    });

    it(@"should properly initialize initWithDictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameParentID:@(testParentId),
                                       SDLRPCParameterNamePosition:@(testPosition),
                                       SDLRPCParameterNameMenuName:testMenuName};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.parentID).to(equal(@(testParentId)));
        expect(testStruct.position).to(equal(@(testPosition)));
        expect(testStruct.menuName).to(equal(testMenuName));
    });

    it(@"should properly initialize initWithMenuName", ^{
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] initWithMenuName:testMenuName];

        expect(testStruct.parentID).to(beNil());
        expect(testStruct.position).to(beNil());
        expect(testStruct.menuName).to(equal(testMenuName));
    });

    it(@"should properly initialize initWithMenuName:parentId:position:", ^{
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] initWithMenuName:testMenuName parentId:testParentId position:testPosition];

        expect(testStruct.parentID).to(equal(@(testParentId)));
        expect(testStruct.position).to(equal(@(testPosition)));
        expect(testStruct.menuName).to(equal(testMenuName));
    });
});

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^{
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] init];
        
        testStruct.parentID = @504320489;
        testStruct.position = @256;
        testStruct.menuName = @"Menu";
        
        expect(testStruct.parentID).to(equal(@504320489));
        expect(testStruct.position).to(equal(@256));
        expect(testStruct.menuName).to(equal(@"Menu"));
    });
});

QuickSpecEnd
