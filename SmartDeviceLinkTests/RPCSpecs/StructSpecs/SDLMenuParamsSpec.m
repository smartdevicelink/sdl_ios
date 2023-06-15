//
//  SDLMenuParamsSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLMenuParams.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLMenuParamsSpec)

describe(@"Initialization tests", ^{
    __block UInt32 testParentId = 504320489;
    __block UInt16 testPosition = testPosition;
    __block NSString *testMenuName = @"Test Menu";
    __block NSString *testSecondaryText = @"Test text 2";
    __block NSString *testTertiaryText = @"Test text 3";

    it(@"should properly initialize init", ^{
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] init];

        expect(testStruct.parentID).to(beNil());
        expect(testStruct.position).to(beNil());
        expect(testStruct.menuName).to(beNil());
        expect(testStruct.secondaryText).to(beNil());
        expect(testStruct.tertiaryText).to(beNil());
    });

    it(@"should properly initialize initWithDictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameParentID:@(testParentId),
                                       SDLRPCParameterNamePosition:@(testPosition),
                                       SDLRPCParameterNameMenuName:testMenuName,
                                       SDLRPCParameterNameSecondaryText:testSecondaryText,
                                       SDLRPCParameterNameTertiaryText:testTertiaryText};
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] initWithDictionary:dict];

        expect(testStruct.parentID).to(equal(@(testParentId)));
        expect(testStruct.position).to(equal(@(testPosition)));
        expect(testStruct.menuName).to(equal(testMenuName));
        expect(testStruct.secondaryText).to(equal(testSecondaryText));
        expect(testStruct.tertiaryText).to(equal(testTertiaryText));
    });

    it(@"should properly initialize initWithMenuName", ^{
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] initWithMenuName:testMenuName];

        expect(testStruct.parentID).to(beNil());
        expect(testStruct.position).to(beNil());
        expect(testStruct.menuName).to(equal(testMenuName));
    });

    it(@"should properly initialize initWithMenuName:parentId:position:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] initWithMenuName:testMenuName parentId:testParentId position:testPosition];
#pragma clang diagnostic pop

        expect(testStruct.parentID).to(equal(@(testParentId)));
        expect(testStruct.position).to(equal(@(testPosition)));
        expect(testStruct.menuName).to(equal(testMenuName));
    });

    it(@"should properly initialize initWithMenuName:parentID:position:secondaryText:tertiaryText:", ^{
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] initWithMenuName:testMenuName parentID:[[NSNumber alloc] initWithInt:testParentId] position:[[NSNumber alloc] initWithInt:testPosition] secondaryText:testSecondaryText tertiaryText:testTertiaryText];

        expect(testStruct.parentID).to(equal(@(testParentId)));
        expect(testStruct.position).to(equal(@(testPosition)));
        expect(testStruct.menuName).to(equal(testMenuName));
        expect(testStruct.secondaryText).to(equal(testSecondaryText));
        expect(testStruct.tertiaryText).to(equal(testTertiaryText));
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
