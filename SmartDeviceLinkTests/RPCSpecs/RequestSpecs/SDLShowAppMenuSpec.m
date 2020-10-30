//
//  SDLShowAppMenuSpec.m
//  SmartDeviceLinkTests
//
//  Created by Justin Gluck on 7/15/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLShowAppMenu.h"

QuickSpecBegin(SDLShowAppMenuSpec)
describe(@"Getter/Setter Tests", ^ {
    __block UInt32 menuId = 4345645;

    it(@"Should set and get correctly", ^ {
        SDLShowAppMenu *testRequest = [[SDLShowAppMenu alloc] init];

        testRequest.menuID = @(menuId);

        expect(testRequest.menuID).to(equal(testRequest.menuID));
    });

    it(@"Should get correctly when initialized with dictonary", ^ {
        NSDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameMenuID:@4345645,
                                                                   },
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameShowAppMenu}} mutableCopy];
        SDLShowAppMenu* testRequest = [[SDLShowAppMenu alloc] initWithDictionary:dict];
         expect(testRequest.menuID).to(equal(@(menuId)));
    });

    it(@"Should return nil if not set", ^ {
        SDLShowAppMenu *testRequest = [[SDLShowAppMenu alloc] init];

        expect(testRequest.menuID).to(beNil());
    });

});
QuickSpecEnd
