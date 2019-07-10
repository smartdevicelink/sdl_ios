//
//  SDLRPCMessage.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCMessage.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLRPCMessageSpec)

describe(@"Readonly Property Tests", ^ {
    it(@"Should get name correctly when initialized with name", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@"Poorly Named"];
#pragma clang diagnostic pop
        
        expect(testMessage.name).to(equal(@"Poorly Named"));
    });
    
    it(@"Should get correctly when initialized with dictionary", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithDictionary:[@{SDLRPCParameterNameNotification:
                                                                                      @{SDLRPCParameterNameParameters:
                                                                                            @{@"name":@"George"},
                                                                                        SDLRPCParameterNameOperationName:@"Poorly Named"}} mutableCopy]];
#pragma clang diagnostic pop
        
        expect(testMessage.name).to(equal(@"Poorly Named"));
        expect(testMessage.messageType).to(equal(SDLRPCParameterNameNotification));
    });
});

describe(@"Parameter Tests", ^ {
    it(@"Should set and get correctly", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@""];
        
        [testMessage setParameters:@"ADogAPanicInAPagoda" value:@"adogaPAnIcinaPAgoDA"];
        expect([testMessage getParameters:@"ADogAPanicInAPagoda"]).to(equal(@"adogaPAnIcinaPAgoDA"));
#pragma clang diagnostic pop

        expect(testMessage.parameters[@"ADogAPanicInAPagoda"]).to(equal(@"adogaPAnIcinaPAgoDA"));
    });
    
    it(@"Should get correctly when initialized", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithDictionary:[@{SDLRPCParameterNameResponse:
                                                                                      @{SDLRPCParameterNameParameters:
                                                                                            @{@"age":@25},
                                                                                        SDLRPCParameterNameOperationName:@"Nameless"}} mutableCopy]];
#pragma clang diagnostic pop
        
        expect(testMessage.parameters[@"age"]).to(equal(@25));
    });
    
    it(@"Should be nil if not set", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@""];
        
        expect(testMessage.parameters[@"ADogAPanicInAPagoda"]).to(beNil());
#pragma clang diagnostic pop
    });
});

describe(@"FunctionName Tests", ^ {
    it(@"Should set and get correctly", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@""];
        
        [testMessage setFunctionName:@"Functioning"];
#pragma clang diagnostic pop
        
        expect(testMessage.name).to(equal(@"Functioning"));
    });
    
    it(@"Should get correctly when initialized", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithDictionary:[@{SDLRPCParameterNameRequest:
                                                                                      @{SDLRPCParameterNameParameters:
                                                                                            @{@"age":@25},
                                                                                        SDLRPCParameterNameOperationName:@"DoNothing"}} mutableCopy]];
#pragma clang diagnostic pop
        
        expect(testMessage.name).to(equal(@"DoNothing"));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testMessage = [[SDLRPCMessage alloc] initWithName:@"DoSomething"];
#pragma clang diagnostic pop
        
        expect(testMessage.name).to(equal(@"DoSomething"));
    });
    
    it(@"Should be nil if not set", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithDictionary:[@{SDLRPCParameterNameNotification:
                                                                                      @{SDLRPCParameterNameParameters:
                                                                                            @{}}} mutableCopy]];
#pragma clang diagnostic pop
        expect(testMessage.name).to(beNil());
    });
});

describe(@"BulkDataTests", ^ {
    it(@"Should set and get correctly", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@""];
#pragma clang diagnostic pop
        
        const char* testString = "ImportantData";
        testMessage.bulkData = [NSData dataWithBytes:testString length:strlen(testString)];
        
        expect([NSString stringWithUTF8String:testMessage.bulkData.bytes]).to(equal(@"ImportantData"));
    });
    
    it(@"Should get correctly when initialized", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithDictionary:[@{SDLRPCParameterNameNotification:
                                                                                      @{SDLRPCParameterNameParameters:
                                                                                            @{}},
                                                                                  SDLRPCParameterNameBulkData:[NSData dataWithBytes:"ImageData" length:strlen("ImageData")]} mutableCopy]];
#pragma clang diagnostic pop
        
        expect(testMessage.bulkData).to(equal([NSData dataWithBytes:"ImageData" length:strlen("ImageData")]));
    });
    
    it(@"Should be nil if not set", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@""];
#pragma clang diagnostic pop
        
        expect(testMessage.bulkData).to(beNil());
    });
});

QuickSpecEnd
