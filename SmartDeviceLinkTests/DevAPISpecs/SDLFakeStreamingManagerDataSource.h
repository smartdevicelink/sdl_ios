//
//  SDLFakeStreamingManagerDataSource.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 9/5/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLStreamingMediaManagerDataSource.h"

@interface SDLFakeStreamingManagerDataSource : NSObject <SDLStreamingMediaManagerDataSource>

@property (strong, nonatomic, readonly) SDLVideoStreamingFormat *extraFormat;

@end
