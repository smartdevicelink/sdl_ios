//
//  SDLRPCMessage.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCMessage.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLRPCMessageSpec)

describe(@"Getter/Setter Tests", ^ {
    __block NSString *testRPCName = @"Test RPC Name";
    __block NSString *testNameKey = @"firstName";
    __block NSString *testNameValue = @"George";
    __block NSString *testAgeKey = @"age";
    __block NSNumber *testAgeValue = @25;
    const char *testString = "ImportantData";
    __block NSData *testBulkData = nil;

    beforeEach(^{
        testBulkData = [NSData dataWithBytes:testString length:strlen(testString)];;
    });

    it(@"should get correctly when initialized with initWithName:", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage *testMessage = [[SDLRPCMessage alloc] initWithName:testRPCName];
#pragma clang diagnostic pop
        
        expect(testMessage.name).to(equal(testRPCName));
        expect(testMessage.parameters).to(beEmpty());
        expect(testMessage.bulkData).to(beNil());
        expect(testMessage.messageType).to(equal(SDLRPCParameterNameRequest));
    });
    
    it(@"should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameNotification:
                                   @{SDLRPCParameterNameParameters:
                                         @{testNameKey:testNameValue,
                                           testAgeKey:testAgeValue,
                                         },
                                         SDLRPCParameterNameOperationName:testRPCName
                                   },
                               SDLRPCParameterNameBulkData:testBulkData,
        };
        SDLRPCMessage *testMessage = [[SDLRPCMessage alloc] initWithDictionary:dict];

        expect(testMessage.name).to(equal(testRPCName));
        expect(testMessage.parameters[testNameKey]).to(equal(testNameValue));
        expect(testMessage.parameters[testAgeKey]).to(equal(testAgeValue));
        expect(testMessage.bulkData).to(equal(testBulkData));
        expect([NSString stringWithUTF8String:testMessage.bulkData.bytes]).to(equal([NSString stringWithUTF8String:testBulkData.bytes]));
        expect(testMessage.messageType).to(equal(SDLRPCParameterNameNotification));
    });

    it(@"should set and get correctly", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage *testMessage = [[SDLRPCMessage alloc] initWithName:testRPCName];
#pragma clang diagnostic pop

        testMessage.parameters[testAgeKey] = testAgeValue;
        testMessage.parameters[testNameKey] = testNameValue;
        testMessage.bulkData = testBulkData;

        expect(testMessage.name).to(equal(testRPCName));
        expect(testMessage.parameters[testAgeKey]).to(equal(testAgeValue));
        expect(testMessage.parameters[testNameKey]).to(equal(testNameValue));
        expect(testMessage.bulkData).to(equal(testBulkData));
        expect([NSString stringWithUTF8String:testMessage.bulkData.bytes]).to(equal([NSString stringWithUTF8String:testBulkData.bytes]));
        expect(testMessage.messageType).to(equal(SDLRPCParameterNameRequest));
    });

    it(@"should set and get correctly with setter methods", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage *testMessage = [[SDLRPCMessage alloc] initWithName:@""];
        [testMessage setFunctionName:testRPCName];
        [testMessage setParameters:testAgeKey value:testAgeValue];
        [testMessage setParameters:testNameKey value:testNameValue];
        [testMessage setBulkData:testBulkData];
#pragma clang diagnostic pop

        expect(testMessage.name).to(equal(testRPCName));
        expect(testMessage.parameters[testAgeKey]).to(equal(testAgeValue));
        expect(testMessage.parameters[testNameKey]).to(equal(testNameValue));
        expect(testMessage.bulkData).to(equal(testBulkData));
        expect([NSString stringWithUTF8String:testMessage.bulkData.bytes]).to(equal([NSString stringWithUTF8String:testBulkData.bytes]));
        expect(testMessage.messageType).to(equal(SDLRPCParameterNameRequest));
    });
});

QuickSpecEnd
