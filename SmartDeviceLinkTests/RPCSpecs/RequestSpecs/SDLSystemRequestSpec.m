//
//  SDLSystemRequestSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLSystemRequest.h"
#import "SDLRequestType.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLSystemRequestSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLRequestType testRequestType = SDLRequestTypeAuthenticationRequest;
    __block NSString *testSubType = @"subtype";
    __block NSString *testFileName = @"AnotherFile";

    describe(@"initializers", ^{
        it(@"should get correctly when initialized with dictionary", ^ {
            NSMutableDictionary* dict = [@{SDLRPCParameterNameRequest:
                                               @{SDLRPCParameterNameParameters:
                                                     @{SDLRPCParameterNameRequestType:SDLRequestTypeAuthenticationRequest,
                                                       SDLRPCParameterNameRequestSubType: testSubType,
                                                       SDLRPCParameterNameFileName:testFileName},
                                                 SDLRPCParameterNameOperationName:SDLRPCFunctionNameSystemRequest}} mutableCopy];
            SDLSystemRequest* testRequest = [[SDLSystemRequest alloc] initWithDictionary:dict];

            expect(testRequest.requestType).to(equal(testRequestType));
            expect(testRequest.requestSubType).to(equal(testSubType));
            expect(testRequest.fileName).to(equal(testFileName));
        });

        it(@"should be correctly initialized with initWithRequestType:fileName:", ^{
            SDLSystemRequest *testRequest = [[SDLSystemRequest alloc] initWithType:testRequestType fileName:testFileName];
            expect(testRequest.requestType).to(equal(testRequestType));
            expect(testRequest.requestSubType).to(beNil());
            expect(testRequest.fileName).to(equal(testFileName));
        });

        it(@"should be correctly initialized with initWithProprietaryType:fileName:", ^{
            SDLSystemRequest *testRequest = [[SDLSystemRequest alloc] initWithProprietaryType:testSubType fileName:testFileName];
            expect(testRequest.requestType).to(equal(SDLRequestTypeOEMSpecific));
            expect(testRequest.requestSubType).to(equal(testSubType));
            expect(testRequest.fileName).to(equal(testFileName));
        });

        it(@"Should return nil if not set", ^ {
            SDLSystemRequest* testRequest = [[SDLSystemRequest alloc] init];

            expect(testRequest.requestType).to(beNil());
            expect(testRequest.requestSubType).to(beNil());
            expect(testRequest.fileName).to(beNil());
        });
    });

    it(@"Should set and get correctly", ^ {
        SDLSystemRequest* testRequest = [[SDLSystemRequest alloc] init];
        
        testRequest.requestType = testRequestType;
        testRequest.requestSubType = testSubType;
        testRequest.fileName = testFileName;
        
        expect(testRequest.requestType).to(equal(SDLRequestTypeAuthenticationRequest));
        expect(testRequest.requestSubType).to(equal(testSubType));
        expect(testRequest.fileName).to(equal(testFileName));
    });
});

QuickSpecEnd
