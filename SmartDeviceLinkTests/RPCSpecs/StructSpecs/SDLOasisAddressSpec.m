//  SDLOasisAddressSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOasisAddress.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOasisAddressSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOasisAddress* testStruct = [[SDLOasisAddress alloc] init];
        
        testStruct.countryName = @"United States";
        testStruct.countryCode = @"US";
        testStruct.postalCode = @"123456";
        testStruct.administrativeArea = @"CA";
        testStruct.subAdministrativeArea = @"Santa Clara";
        testStruct.locality = @"Palo Alto";
        testStruct.subLocality = @"18";
        testStruct.thoroughfare = @"Candy Lane";
        testStruct.subThoroughfare = @"123";
        
        expect(testStruct.countryName).to(equal(@"United States"));
        expect(testStruct.countryCode).to(equal(@"US"));
        expect(testStruct.postalCode).to(equal(@"123456"));
        expect(testStruct.administrativeArea).to(equal(@"CA"));
        expect(testStruct.subAdministrativeArea).to(equal(@"Santa Clara"));
        expect(testStruct.locality).to(equal(@"Palo Alto"));
        expect(testStruct.subLocality).to(equal(@"18"));
        expect(testStruct.thoroughfare).to(equal(@"Candy Lane"));
        expect(testStruct.subThoroughfare).to(equal(@"123"));

    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_countryName:@"United States",
                                       NAMES_countryCode:@"US",
                                       NAMES_postalCode:@"123456",
                                       NAMES_administrativeArea:@"CA",
                                       NAMES_subAdministrativeArea:@"Santa Clara",
                                       NAMES_locality:@"Palo Alto",
                                       NAMES_subLocality:@"18",
                                       NAMES_thoroughfare:@"Candy Lane",
                                       NAMES_subThoroughfare:@"123"} mutableCopy];
        SDLOasisAddress* testStruct = [[SDLOasisAddress alloc] initWithDictionary:dict];
        
        expect(testStruct.countryName).to(equal(@"United States"));
        expect(testStruct.countryCode).to(equal(@"US"));
        expect(testStruct.postalCode).to(equal(@"123456"));
        expect(testStruct.administrativeArea).to(equal(@"CA"));
        expect(testStruct.subAdministrativeArea).to(equal(@"Santa Clara"));
        expect(testStruct.locality).to(equal(@"Palo Alto"));
        expect(testStruct.subLocality).to(equal(@"18"));
        expect(testStruct.thoroughfare).to(equal(@"Candy Lane"));
        expect(testStruct.subThoroughfare).to(equal(@"123"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOasisAddress* testStruct = [[SDLOasisAddress alloc] init];
        
        expect(testStruct.countryName).to(beNil());
        expect(testStruct.countryCode).to(beNil());
        expect(testStruct.postalCode).to(beNil());
        expect(testStruct.administrativeArea).to(beNil());
        expect(testStruct.subAdministrativeArea).to(beNil());
        expect(testStruct.locality).to(beNil());
        expect(testStruct.subLocality).to(beNil());
        expect(testStruct.thoroughfare).to(beNil());
        expect(testStruct.subThoroughfare).to(beNil());
    });
});

QuickSpecEnd
