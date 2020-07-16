//
//  SDLOnSystemRequestSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFileType.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLOnSystemRequest.h"
#import "SDLRequestType.h"


QuickSpecBegin(SDLOnSystemRequestSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnSystemRequest* testNotification = [[SDLOnSystemRequest alloc] init];
        
        testNotification.requestType = SDLRequestTypeFileResume;
        testNotification.requestSubType = @"subtype";
        testNotification.url = @"www.google.com";
        testNotification.timeout = @52345;
        testNotification.fileType = SDLFileTypePNG;
        testNotification.offset = @2532678684;
        testNotification.length = @50000000000;
        
        expect(testNotification.requestType).to(equal(SDLRequestTypeFileResume));
        expect(testNotification.requestSubType).to(equal(@"subtype"));
        expect(testNotification.url).to(equal(@"www.google.com"));
        expect(testNotification.timeout).to(equal(@52345));
        expect(testNotification.fileType).to(equal(SDLFileTypePNG));
        expect(testNotification.offset).to(equal(@2532678684));
        expect(testNotification.length).to(equal(@50000000000));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameRequestType:SDLRequestTypeFileResume,
                                                   SDLRPCParameterNameRequestSubType: @"subtype",
                                                   SDLRPCParameterNameURL:@"www.google.com",
                                                   SDLRPCParameterNameTimeout:@52345,
                                                   SDLRPCParameterNameFileType:SDLFileTypePNG,
                                                   SDLRPCParameterNameOffset:@2532678684,
                                                   SDLRPCParameterNameLength:@50000000000},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnSystemRequest}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnSystemRequest* testNotification = [[SDLOnSystemRequest alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.requestType).to(equal(SDLRequestTypeFileResume));
        expect(testNotification.requestSubType).to(equal(@"subtype"));
        expect(testNotification.url).to(equal([@"www.google.com" mutableCopy]));
        expect(testNotification.timeout).to(equal(@52345));
        expect(testNotification.fileType).to(equal(SDLFileTypePNG));
        expect(testNotification.offset).to(equal(@2532678684));
        expect(testNotification.length).to(equal(@50000000000));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnSystemRequest* testNotification = [[SDLOnSystemRequest alloc] init];
        
        expect(testNotification.requestType).to(beNil());
        expect(testNotification.requestSubType).to(beNil());
        expect(testNotification.url).to(beNil());
        expect(testNotification.timeout).to(beNil());
        expect(testNotification.fileType).to(beNil());
        expect(testNotification.offset).to(beNil());
        expect(testNotification.length).to(beNil());
    });

    it(@"Should set and get url correctly (zero length url)", ^ {
        SDLOnSystemRequest* testRequest = [[SDLOnSystemRequest alloc] init];
        NSString *testURL = @"";
        testRequest.url = testURL;
        expect(testRequest.url).to(equal(testURL));
    });

    it(@"Should set and get url correctly (1000 sym long url)", ^ {
        const int size = 1000;
        SDLOnSystemRequest* testRequest = [[SDLOnSystemRequest alloc] init];
        NSMutableString *testURL = [NSMutableString stringWithCapacity:1024];
        [testURL setString:@"www.google.com"];
        while(size > testURL.length) {
            [testURL appendString:@"/testcomponent"];
        }
        if (size < testURL.length) {
            const NSRange range = NSMakeRange(size, testURL.length - size);
            [testURL deleteCharactersInRange:range];
        }
        testRequest.url = testURL;
        expect(testRequest.url).to(equal(testURL));
    });

    it(@"Should set and get url correctly (extra long url)", ^ {
        const int size = 1024 * 1024;
        SDLOnSystemRequest* testRequest = [[SDLOnSystemRequest alloc] init];
        NSMutableString *testURL = [NSMutableString stringWithCapacity:size + 20];
        [testURL setString:@"www.google.com"];
        while(size > testURL.length) {
            [testURL appendString:@"/testcomponent"];
        }
        if (size < testURL.length) {
            const NSRange range = NSMakeRange(size, testURL.length - size);
            [testURL deleteCharactersInRange:range];
        }
        testRequest.url = testURL;
        expect(testRequest.url).to(equal(testURL));
    });
});

QuickSpecEnd
