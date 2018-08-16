//
//  SDLPutFileResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPutFileResponse.h"
#import "SDLNames.h"

QuickSpecBegin(SDLPutFileResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPutFileResponse* testResponse = [[SDLPutFileResponse alloc] init];
        
        testResponse.spaceAvailable = @1248;

        expect(testResponse.spaceAvailable).to(equal(@1248));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary<NSString *, id> *dict = @{SDLNameResponse:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameSpaceAvailable:@1248,
                                                                   },
                                                             SDLNameOperationName:SDLNamePutFile}};
        SDLPutFileResponse* testResponse = [[SDLPutFileResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.spaceAvailable).to(equal(@1248));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLPutFileResponse* testResponse = [[SDLPutFileResponse alloc] init];
        
        expect(testResponse.spaceAvailable).to(beNil());
    });
});

QuickSpecEnd
