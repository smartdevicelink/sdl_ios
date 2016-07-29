//
//  CGPointUtilSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 7/1/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "CGPoint_Util.h"

QuickSpecBegin(CGPointUtilSpec)

describe(@"CGPoint_Util Tests", ^{
    __block CGPoint first;
    __block CGPoint second;
    context(@"For two positive points", ^{
        beforeEach(^{
            first = CGPointMake(100, 200);
            second = CGPointMake(300, 400);
        });
        
        it(@"should properly calculate the center between points", ^{
            CGPoint center = CGPointCenterOfPoints(first, second);
            expect(@(center.x)).to(equal(@200));
            expect(@(center.y)).to(equal(@300));
        });
        it(@"should properly calculate the distance between points", ^{
            CGFloat distance = CGPointDistanceBetweenPoints(first, second);
            expect(@(distance)).to(beCloseTo(@282.8427).within(0.0001));
        });
    });
    context(@"For two negative points", ^{
        beforeEach(^{
            first = CGPointMake(-100, -200);
            second = CGPointMake(-300, -400);
        });
        
        it(@"should properly calculate the center between points", ^{
            CGPoint center = CGPointCenterOfPoints(first, second);
            expect(@(center.x)).to(equal(@(-200)));
            expect(@(center.y)).to(equal(@(-300)));
        });
        it(@"should properly calculate the distance between points", ^{
            CGFloat distance = CGPointDistanceBetweenPoints(first, second);
            expect(@(distance)).to(beCloseTo(@282.8427).within(0.0001));
        });
    });
    context(@"For one positive and one negative point", ^{
        beforeEach(^{
            first = CGPointMake(100, 200);
            second = CGPointMake(-300, -400);
        });
        
        it(@"should properly calculate the center between points", ^{
            CGPoint center = CGPointCenterOfPoints(first, second);
            expect(@(center.x)).to(equal(@(-100)));
            expect(@(center.y)).to(equal(@(-100)));
        });
        it(@"should properly calculate the distance between points", ^{
            CGFloat distance = CGPointDistanceBetweenPoints(first, second);
            expect(@(distance)).to(beCloseTo(@721.1103).within(0.0001));
        });
    });
});

QuickSpecEnd