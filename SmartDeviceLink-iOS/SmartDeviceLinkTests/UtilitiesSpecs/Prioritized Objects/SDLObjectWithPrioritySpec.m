//
//  SDLObjectWithPrioritySpec.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/27/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLObjectWithPriority.h"


QuickSpecBegin(SDLObjectWithPrioritySpec)

describe(@"a prioritized object", ^{
    it(@"should initialize properly", ^{
        SDLObjectWithPriority *object = [[SDLObjectWithPriority alloc] init];
        
        expect(object).toNot(beNil());
        expect(object.object).to(beNil());
        expect(@(object.priority)).to(equal(@0));
    });
    
    it(@"should store an object properly", ^{
        NSString *testString = @"TestString";
        SDLObjectWithPriority *object = [[SDLObjectWithPriority alloc] init];
        
        object.object = testString;
        object.priority = 100;
        
        expect(object.object).to(equal(testString));
        expect(@(object.priority)).to(equal(@100));
    });
});

QuickSpecEnd
