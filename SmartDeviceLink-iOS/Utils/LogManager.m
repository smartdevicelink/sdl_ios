//
//  LogManager.m
//  SmartDeviceLink-Example
//
//  Created by pactera on 2018/5/8.
//  Copyright © 2018年 smartdevicelink. All rights reserved.
//

#import "LogManager.h"

@implementation LogManager

static LogManager *instance = nil;

+ (LogManager *)shareInstance{
    if(instance == nil){
        instance = [[LogManager alloc] init];
    }
    return instance;
}

- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];//注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    //先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);
}

//alloc的时候调用
+ (id) allocWithZone:(struct _NSZone *)zone{
    if(instance == nil){
        instance = [super allocWithZone:zone];
    }
    return instance;
}

//拷贝方法
- (id)copyWithZone:(NSZone *)zone{
    return instance;
}
////此函数要在
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//中调用，这个函数在AppDelegate.m中实现的。
///*******************************************************************************/
////当真机连接Mac调试的时候把这些注释掉，否则log只会输入到文件中，而不能从xcode的监视器中看到。
//// 如果是真机就保存到Document目录下的dr.log文件中
//UIDevice *device = [UIDevicecurrentDevice];
//if (![[device model]isEqualToString:@"iPad Simulator"]) {
//    // 开始保存日志文件
//    [self redirectNSlogToDocumentFolder];
//}
/*******************************************************************************/
@end
