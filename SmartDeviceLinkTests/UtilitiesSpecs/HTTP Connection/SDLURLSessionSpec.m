#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "SDLURLSession.h"

QuickSpecBegin(SDLURLSessionSpec)

describe(@"the url session", ^{
    __block SDLURLSession *testSession = nil;
    
    describe(@"attempting to get good data", ^{
        context(@"from an https address", ^{
            context(@"uploading data", ^{
                NSData *testData = [@"testData" dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *someJSONObject = @[@"one", @"two"];
                NSData *testJSONData = [NSJSONSerialization dataWithJSONObject:someJSONObject options:0 error:nil];
                
                __block NSData *testReturnData = nil;
                __block NSURLResponse *testReturnResponse = nil;
                __block NSError *testReturnError = nil;
                __block NSArray *testReturnJSONObject = nil;
                
                beforeEach(^{
                    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                        if ([request.URL.host isEqualToString:@"www.faketest.com"]) {
                            testReturnJSONObject = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil];
                            return YES;
                        }
                        
                        return NO;
                    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                        return [[OHHTTPStubsResponse responseWithData:testData statusCode:200 headers:nil] requestTime:0.5 responseTime:0];
                    }];
                    
                    testSession = [[SDLURLSession alloc] init];
                    NSURLRequest *someURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.faketest.com"]];
                    
                    [testSession uploadWithURLRequest:someURLRequest data:testJSONData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        testReturnData = data;
                        testReturnResponse = response;
                        testReturnError = error;
                    }];
                });
                
                afterEach(^{
                    testSession = nil;
                    [OHHTTPStubs removeAllStubs];
                });
                
                it(@"should have correct data", ^{
                    expect(testReturnJSONObject).toEventually(equal(someJSONObject));
                    expect(testReturnData).toEventually(equal(testData));
                    expect(testReturnResponse).toEventuallyNot(beNil());
                    expect(testReturnError).toEventually(beNil());
                });
            });
            
            context(@"downloading data", ^{
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
                    
                    testSession = [[SDLURLSession alloc] init];
                    [testSession dataFromURL:[NSURL URLWithString:@"https://www.faketest.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        testReturnData = data;
                        testReturnResponse = response;
                        testReturnError = error;
                    }];
                });
                
                afterEach(^{
                    testSession = nil;
                    [OHHTTPStubs removeAllStubs];
                });
                
                it(@"should return correct info", ^{
                    expect(testReturnData).toEventually(equal(testData));
                    expect(testReturnResponse).toEventuallyNot(beNil());
                    expect(testReturnError).toEventually(beNil());
                });
            });
        });
        
        context(@"from an http address", ^{
            NSData *testData = [@"testData" dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *someJSONObject = @[@"one", @"two"];
            NSData *testJSONData = [NSJSONSerialization dataWithJSONObject:someJSONObject options:0 error:nil];
            
            __block NSString *testURLRequestComponent = nil;
            
            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    if ([request.URL.host isEqualToString:@"www.faketest.com"]) {
                        testURLRequestComponent = request.URL.scheme;
                        return YES;
                    }
                    
                    return NO;
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [[OHHTTPStubsResponse responseWithData:testData statusCode:200 headers:request.allHTTPHeaderFields] requestTime:0.5 responseTime:0];
                }];
                
                testSession = [[SDLURLSession alloc] init];
                NSURLRequest *someURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.faketest.com"]];
                
                [testSession uploadWithURLRequest:someURLRequest data:testJSONData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {}];
            });
            
            afterEach(^{
                testSession = nil;
                [OHHTTPStubs removeAllStubs];
            });
            
            it(@"should have called the HTTPS URL instead", ^{
                expect(testURLRequestComponent).toEventually(match(@"https"));
            });
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
            
            testSession = [[SDLURLSession alloc] init];
            [testSession dataFromURL:[NSURL URLWithString:@"http://www.faketest.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                testReturnData = data;
                testReturnResponse = response;
                testReturnError = error;
            }];
        });
        
        afterEach(^{
            testSession = nil;
            [OHHTTPStubs removeAllStubs];
        });
        
        it(@"should return nil data", ^{
            expect(testReturnData).toEventually(beNil());
            expect(testReturnResponse).toEventually(beNil());
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
            
            testSession = [[SDLURLSession alloc] init];
            [testSession dataFromURL:[NSURL URLWithString:@"http://www.faketest.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                testReturnData = data;
                testReturnResponse = response;
                testReturnError = error;
            }];
            
            [testSession cancelAllTasks];
        });
        
        afterEach(^{
            testSession = nil;
            [OHHTTPStubs removeAllStubs];
        });
        
        it(@"should return nil data", ^{
            expect(testReturnData).toEventually(beNil());
            expect(testReturnResponse).toEventually(beNil());
            expect(@(testReturnError.code)).toEventually(equal(@(kCFURLErrorCancelled)));
        });
    });
});

QuickSpecEnd
