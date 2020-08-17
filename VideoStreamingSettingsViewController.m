//
//  VideoStreamingSettingsViewController.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Leonid Lokhmatov on 7/28/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import "VideoStreamingSettingsViewController.h"
#import "SDLImageResolution.h"
#import "SDLSupportedStreamingRange.h"

@interface VideoStreamingSettingsViewController ()
@property (nonatomic, strong) IBOutlet UILabel *labDescription;
@property (nonatomic, strong) IBOutlet UISegmentedControl *toggleSDLVersion;
@end

static NSString *const VersionString6 = @"6.2.0";
static NSString *const VersionString7 = @"7.0.0";

@implementation VideoStreamingSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.videoStreamSettings) {
        self.videoStreamSettings = [VideoStreamSettings new];
    }
    [self showSettingsOnScreen];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self applyDataModel];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, segue);
}

- (IBAction)actionAccept:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"accept settings");
//    }];
}

- (IBAction)actionSwitchSDLVersion:(UISegmentedControl*)segments {
    self.videoStreamSettings.SDLVersion = 0 == segments.selectedSegmentIndex ? VersionString6 : VersionString7;
    [self showSettingsOnScreen];
}

- (IBAction)actionSwitchPortraitPreset:(UISegmentedControl*)segments {
    switch (segments.selectedSegmentIndex) {
        default:
        case 0: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:98 height:200];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:1000 height:2000];
            strRange.minimumDiagonal = 0.5;
            strRange.minimumAspectRatio = 1.0;
            strRange.maximumAspectRatio = 2.0;
            self.videoStreamSettings.supportedPortraitStreamingRange = strRange;
        } break;

        case 1: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:99 height:200];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:1000 height:3000];
            strRange.minimumDiagonal = 2;
            strRange.minimumAspectRatio = 1.0;
            strRange.maximumAspectRatio = 2.5;
            self.videoStreamSettings.supportedPortraitStreamingRange = strRange;
        } break;

        case 2: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:100 height:200];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:1000 height:4000];
            strRange.minimumDiagonal = 5;
            strRange.minimumAspectRatio = 1.0;
            strRange.maximumAspectRatio = 3.0;
            self.videoStreamSettings.supportedPortraitStreamingRange = strRange;
        } break;
    }

    [self showSettingsOnScreen];
}

- (IBAction)actionSwitchLandscapePreset:(UISegmentedControl*)segments {
    switch (segments.selectedSegmentIndex) {
        default:
        case 0: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:200 height:98];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:2000 height:1000];
            strRange.minimumDiagonal = 0.5;
            strRange.minimumAspectRatio = 1.0;
            strRange.maximumAspectRatio = 2.0;
            self.videoStreamSettings.supportedLandscapeStreamingRange = strRange;
        } break;

        case 1: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:200 height:99];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:3000 height:1000];
            strRange.minimumDiagonal = 7.0;
            strRange.minimumAspectRatio = 1.0;
            strRange.maximumAspectRatio = 2.5;
            self.videoStreamSettings.supportedLandscapeStreamingRange = strRange;
        } break;

        case 2: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:200 height:100];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:4000 height:1000];
            strRange.minimumDiagonal = 9.0;
            strRange.minimumAspectRatio = 1.0;
            strRange.maximumAspectRatio = 3.0;
            self.videoStreamSettings.supportedLandscapeStreamingRange = strRange;
        } break;
    }

    [self showSettingsOnScreen];
}

#pragma mark - privates

- (void)applyDataModel {
    [self.toggleSDLVersion setSelectedSegmentIndex:[self.videoStreamSettings.SDLVersion isEqualToString:VersionString7] ? 1 : 0];
}

- (void)showSettingsOnScreen {
    self.labDescription.text = [NSString stringWithFormat:@"%@", self.videoStreamSettings.detailedDescription];
}

@end
