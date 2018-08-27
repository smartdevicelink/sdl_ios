//
//  LogManager.h
//  SmartDeviceLink-Example
//
//  Created by pactera on 2018/5/8.
//  Copyright © 2018年 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogManager : NSObject

+ (LogManager *)shareInstance;

- (void)redirectNSlogToDocumentFolder;

@end
