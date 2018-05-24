//
//  SDLCheckChoiceVROptionalOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/24/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLCheckChoiceVROptionalOperation.h"

#import "SDLChoice.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLConnectionManagerType.h"
#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLCheckChoiceVROptionalOperation()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic) SDLChoiceSetManagerCheckVRCompletionHandler completionHandler;

@end

@implementation SDLCheckChoiceVROptionalOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(SDLChoiceSetManagerCheckVRCompletionHandler)completionManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;

    return self;
}

- (void)start {
    [super start];
}

- (void)sdl_sendTestChoices {
    [self.connectionManager sendConnectionRequest:[self.class sdl_testCellWithVR:NO] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            SDLLogD(@"Connected head unit supports choice cells without voice commands. Cells without voice will be sent without voice from now on (no placeholder voice).");

            self.completionHandler(YES, nil);
            return;
        }

        // Check for choice sets with VR
        [self.connectionManager sendConnectionRequest:[self.class sdl_testCellWithVR:YES] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                SDLLogW(@"Connected head unit does not support choice cells without voice commands. Cells without voice will be sent with placeholder voices from now on.");

                self.completionHandler(NO, nil);
                return;
            }

            SDLLogE(@"Connected head unit has rejected all choice cells, choice manager disabled. Error: %@, Response: %@", error, response);
            self.completionHandler(NO, error);
        }];
    }];
}

+ (SDLCreateInteractionChoiceSet *)sdl_testCellWithVR:(BOOL)hasVR {
    SDLChoice *choice = [[SDLChoice alloc] init];
    choice.choiceID = @0;
    choice.menuName = @"Test Cell";
    choice.vrCommands = hasVR ? @[@"Test VR"] : nil;

    SDLCreateInteractionChoiceSet *choiceSet = [[SDLCreateInteractionChoiceSet alloc] initWithId:0 choiceSet:@[choice]];

    return choiceSet;
}

@end

NS_ASSUME_NONNULL_END
