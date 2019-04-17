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
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@"Poorly Named"];
        
        expect(testMessage.name).to(equal(@"Poorly Named"));
    });
    
    it(@"Should get correctly when initialized with dictionary", ^ {
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithDictionary:[@{SDLRPCParameterNameNotification:
                                                                                      @{SDLRPCParameterNameParameters:
                                                                                            @{@"name":@"George"},
                                                                                        SDLRPCParameterNameOperationName:@"Poorly Named"}} mutableCopy]];
        
        expect(testMessage.name).to(equal(@"Poorly Named"));
        expect(testMessage.messageType).to(equal(SDLRPCParameterNameNotification));
    });
});

describe(@"Parameter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@""];
        
        [testMessage setParameters:@"ADogAPanicInAPagoda" value:@"adogaPAnIcinaPAgoDA"];
        
        expect([testMessage getParameters:@"ADogAPanicInAPagoda"]).to(equal(@"adogaPAnIcinaPAgoDA"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithDictionary:[@{SDLRPCParameterNameResponse:
                                                                                      @{SDLRPCParameterNameParameters:
                                                                                            @{@"age":@25},
                                                                                        SDLRPCParameterNameOperationName:@"Nameless"}} mutableCopy]];
        
        expect([testMessage getParameters:@"age"]).to(equal(@25));
    });
    
    it(@"Should be nil if not set", ^ {
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@""];
        
        expect([testMessage getParameters:@"ADogAPanicInAPagoda"]).to(beNil());
    });
});

describe(@"FunctionName Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@""];
        
        [testMessage setFunctionName:@"Functioning"];
        
        expect([testMessage getFunctionName]).to(equal(@"Functioning"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithDictionary:[@{SDLRPCParameterNameRequest:
                                                                                      @{SDLRPCParameterNameParameters:
                                                                                            @{@"age":@25},
                                                                                        SDLRPCParameterNameOperationName:@"DoNothing"}} mutableCopy]];
        
        expect([testMessage getFunctionName]).to(equal(@"DoNothing"));
        
        testMessage = [[SDLRPCMessage alloc] initWithName:@"DoSomething"];
        
        expect([testMessage getFunctionName]).to(equal(@"DoSomething"));
    });
    
    it(@"Should be nil if not set", ^ {
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithDictionary:[@{SDLRPCParameterNameNotification:
                                                                                      @{SDLRPCParameterNameParameters:
                                                                                            @{}}} mutableCopy]];
        expect([testMessage getFunctionName]).to(beNil());
    });
});

describe(@"BulkDataTests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@""];
        
        const char* testString = "ImportantData";
        testMessage.bulkData = [NSData dataWithBytes:testString length:strlen(testString)];
        
        expect([NSString stringWithUTF8String:testMessage.bulkData.bytes]).to(equal(@"ImportantData"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithDictionary:[@{SDLRPCParameterNameNotification:
                                                                                      @{SDLRPCParameterNameParameters:
                                                                                            @{}},
                                                                                  SDLRPCParameterNameBulkData:[NSData dataWithBytes:"ImageData" length:strlen("ImageData")]} mutableCopy]];
        
        expect(testMessage.bulkData).to(equal([NSData dataWithBytes:"ImageData" length:strlen("ImageData")]));
    });
    
    it(@"Should be nil if not set", ^ {
        SDLRPCMessage* testMessage = [[SDLRPCMessage alloc] initWithName:@""];
        
        expect(testMessage.bulkData).to(beNil());
    });
});

QuickSpecEnd
