//
//  VideoStreamingSettingsViewController.m
//  SmartDeviceLink-Example-ObjC
//
//  Copyright © 2020 Luxoft. All rights reserved
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
static NSString *const VersionString0 = @"1.0.0";

@implementation VideoStreamingSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.videoStreamSettings) {
        self.videoStreamSettings = [VideoStreamSettings new];
    }
    [self showSettingsOnScreen];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetSettingsAction:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self applyDataModel];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (IBAction)actionAccept:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionSwitchSDLVersion:(UISegmentedControl*)segments {
    switch (segments.selectedSegmentIndex) {
        case 0:
            self.videoStreamSettings.SDLVersion = VersionString6;
            break;

        case 1:
            self.videoStreamSettings.SDLVersion = VersionString7;
            break;

        default:
            self.videoStreamSettings.SDLVersion = VersionString0;
            break;
    }
    [self showSettingsOnScreen];
}

- (IBAction)actionSwitchPortraitPreset:(UISegmentedControl*)segments {
    switch (segments.selectedSegmentIndex) {
        default:
        case 0: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:30 height:40];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:60 height:80];
            strRange.minimumDiagonal = 0.5;
            strRange.minimumAspectRatio = 1.0;
            strRange.maximumAspectRatio = 2.0;
            self.videoStreamSettings.supportedPortraitStreamingRange = strRange;
        } break;

        case 1: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:100 height:150];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:200 height:300];
            strRange.minimumDiagonal = 2;
            strRange.minimumAspectRatio = 1.0;
            strRange.maximumAspectRatio = 2.5;
            self.videoStreamSettings.supportedPortraitStreamingRange = strRange;
        } break;

        case 2: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:300 height:400];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:900 height:1200];
            strRange.minimumDiagonal = 5;
            strRange.minimumAspectRatio = 2.0;
            strRange.maximumAspectRatio = 5.0;
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
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:45 height:35];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:90 height:70];
            strRange.minimumDiagonal = 0.5;
            strRange.minimumAspectRatio = 1.0;
            strRange.maximumAspectRatio = 2.0;
            self.videoStreamSettings.supportedLandscapeStreamingRange = strRange;
        } break;

        case 1: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:320 height:200];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:350 height:220];
            strRange.minimumDiagonal = 7.0;
            strRange.minimumAspectRatio = 1.0;
            strRange.maximumAspectRatio = 2.5;
            self.videoStreamSettings.supportedLandscapeStreamingRange = strRange;
        } break;

        case 2: {
            SDLSupportedStreamingRange *strRange = [SDLSupportedStreamingRange new];
            strRange.minimumResolution = [[SDLImageResolution alloc] initWithWidth:800 height:380];
            strRange.maximumResolution = [[SDLImageResolution alloc] initWithWidth:820 height:400];
            strRange.minimumDiagonal = 9.0;
            strRange.minimumAspectRatio = 2.0;
            strRange.maximumAspectRatio = 5.0;
            self.videoStreamSettings.supportedLandscapeStreamingRange = strRange;
        } break;
    }

    [self showSettingsOnScreen];
}

- (IBAction)resetSettingsAction:(id)sender {
    self.videoStreamSettings.supportedLandscapeStreamingRange = nil;
    self.videoStreamSettings.supportedPortraitStreamingRange = nil;
    self.videoStreamSettings.SDLVersion = VersionString0;
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
