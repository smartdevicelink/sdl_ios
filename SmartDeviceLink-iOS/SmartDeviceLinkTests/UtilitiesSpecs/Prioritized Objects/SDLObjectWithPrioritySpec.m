//
//  SDLObjectWithPrioritySpec.m
//  SmartDeviceLink-iOS

#import <UIKit/UIKit.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLObjectWithPriority.h"


QuickSpecBegin(SDLObjectWithPrioritySpec)

describe(@"a prioritized object", ^{
    __block SDLObjectWithPriority *testObject = nil;
    
    beforeEach(^{
        testObject = [[SDLObjectWithPriority alloc] init];
    });
    
    describe(@"should initialize properly", ^{
        it(@"should not be nil", ^{
            expect(testObject).toNot(beNil());
        });
        
        it(@"should store a nil object", ^{
            expect(testObject.object).to(beNil());
        });
        
        it(@"should have a priority of 0", ^{
            expect(@(testObject.priority)).to(equal(@(NSIntegerMax)));
        });
    });
    
    describe(@"should store an object properly", ^{
        __block NSString *testString = nil;
        
        beforeEach(^{
            testString = @"TestString";
            testObject.object = testString;
            testObject.priority = 100;
        });
        
        it(@"should store the string as it's object", ^{
            expect(testObject.object).to(equal(testString));
        });
        
        it(@"should set the priority as specified", ^{
            expect(@(testObject.priority)).to(equal(@100));
        });
    });
});

QuickSpecEnd
