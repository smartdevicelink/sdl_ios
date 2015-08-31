#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "SDLURLRequestTask.h"


QuickSpecBegin(SDLURLRequestTaskSpec)

describe(@"a url request task", ^{
    __block SDLURLRequestTask *testTask = nil;
    
    describe(@"when the server returns correct data", ^{
        NSData *testData = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
        
        __block NSData *testReturnData = nil;
        __block NSURLResponse *testReturnResponse = nil;
        __block NSError *testReturnError = nil;
        
        beforeEach(^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.host isEqualToString:@"www.faketest.com"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [[OHHTTPStubsResponse responseWithData:testData statusCode:200 headers:nil] requestTime:0.5 responseTime:0];
            }];
            
            NSURLRequest *someURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.faketest.com"]];
            
            testTask = [[SDLURLRequestTask alloc] initWithURLRequest:someURLRequest completionHandler:^void(NSData *data, NSURLResponse *response, NSError *error) {
                testReturnData = data;
                testReturnResponse = response;
                testReturnError = error;
            }];
        });
        
        afterEach(^{
            testTask = nil;
            [OHHTTPStubs removeAllStubs];
        });
        
        it(@"should return data", ^{
            expect(testReturnData).toEventually(equal(testData));
        });
        
        it(@"should return a response", ^{
            expect(testReturnResponse).toEventuallyNot(beNil());
        });
        
        it(@"should not return an error", ^{
            expect(testReturnError).toEventually(beNil());
        });
    });
    
    describe(@"when the connection fails because there is no internet", ^{
        NSError *someNetworkError = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
        
        __block NSData *testReturnData = nil;
        __block NSURLResponse *testReturnResponse = nil;
        __block NSError *testReturnError = nil;
        
        beforeEach(^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.host isEqualToString:@"www.faketest.com"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithError:someNetworkError];
            }];
            
            NSURLRequest *someURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.faketest.com"]];
            
            testTask = [[SDLURLRequestTask alloc] initWithURLRequest:someURLRequest completionHandler:^void(NSData *data, NSURLResponse *response, NSError *error) {
                testReturnData = data;
                testReturnResponse = response;
                testReturnError = error;
            }];
        });
        
        afterEach(^{
            testTask = nil;
            [OHHTTPStubs removeAllStubs];
        });
        
        it(@"should return nil data", ^{
            expect(testReturnData).toEventually(beNil());
        });
        
        it(@"should return a nil response", ^{
            expect(testReturnResponse).toEventually(beNil());
        });
        
        it(@"should return an error", ^{
            expect(@(testReturnError.code)).toEventually(equal(@(someNetworkError.code)));
        });
    });
    
    describe(@"when the connection fails because it was cancelled", ^{
        NSData *testData = [@"testData" dataUsingEncoding:NSUTF8StringEncoding];
        
        __block NSData *testReturnData = nil;
        __block NSURLResponse *testReturnResponse = nil;
        __block NSError *testReturnError = nil;
        
        beforeEach(^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.host isEqualToString:@"www.faketest.com"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [[OHHTTPStubsResponse responseWithData:testData statusCode:200 headers:nil] requestTime:0.25 responseTime:0.25];
            }];
            
            NSURLRequest *someURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.faketest.com"]];
            
            
            testTask = [[SDLURLRequestTask alloc] initWithURLRequest:someURLRequest completionHandler:^void(NSData *data, NSURLResponse *response, NSError *error) {
                testReturnData = data;
                testReturnResponse = response;
                testReturnError = error;
            }];
            
            [testTask cancel];
        });
        
        afterEach(^{
            testTask = nil;
            [OHHTTPStubs removeAllStubs];
        });
        
        it(@"should return nil data", ^{
            expect(testReturnData).toEventually(beNil());
        });
        
        it(@"should return a nil response", ^{
            expect(testReturnResponse).toEventually(beNil());
        });
        
        it(@"should return an error", ^{
            expect(@(testReturnError.code)).toEventually(equal(@(kCFURLErrorCancelled)));
        });
    });
});

QuickSpecEnd
