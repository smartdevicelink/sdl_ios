//
//  ConnectionTCPTableViewController.m
//  SmartDeviceLink-iOS

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "ConnectionTCPTableViewController.h"
#import "Preferences.h"
#import "ProxyManager.h"
#import "SDLStreamingMediaManager.h"
#import "SDLManager.h"
#import "TestUIAppViewController.h"
#import "SimpleAppViewController.h"
#import "GameViewController.h"
#import "SDLStreamingMediaDelegate.h"
#import "SDLProxy.h"
#import "VideoStreamSettings.h"


typedef NS_ENUM(NSInteger, AppKind) {
    AppKindUIApp,
    AppKindSimple,
    AppKind3DApp,
    AppKindVideoApp,
};

@protocol SDLStreamingMediaDelegate;

@interface ConnectionTCPTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@property (weak, nonatomic) IBOutlet UITableViewCell *connectTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *appSelector;

@property (strong, nonatomic, nullable) UIViewController<SDLStreamingMediaDelegate> *testAppViewController;
@property (assign, nonatomic) AppKind appKind;

@end


@implementation ConnectionTCPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Observe Proxy Manager state
    [[ProxyManager sharedManager] addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:nil];
    
    // Tableview setup
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.ipAddressTextField.text = [Preferences sharedPreferences].ipAddress;
    self.portTextField.text = [@([Preferences sharedPreferences].port) stringValue];
    
    // Connect Button setup
    self.connectButton.tintColor = [UIColor whiteColor];
}

- (void)dealloc {
    @try {
        [[ProxyManager sharedManager] removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
    } @catch (NSException __unused *exception) {}
}


#pragma mark - IBActions

- (IBAction)connectButtonWasPressed:(UIButton *)sender {
    [Preferences sharedPreferences].ipAddress = self.ipAddressTextField.text;
    [Preferences sharedPreferences].port = self.portTextField.text.integerValue;

    [self.view endEditing:YES]; // hide keyboard

    ProxyState state = [ProxyManager sharedManager].state;
    switch (state) {
        case ProxyStateStopped: {
            SDLTCPConfig *tcpConfig = [SDLTCPConfig configWithHost:self.ipAddressTextField.text port:self.portTextField.text.integerValue];

            if (!self.testAppViewController) {
                self.appKind = AppKindSimple;
                self.testAppViewController = [self createTestViewControllerOfType:self.appKind];
            }
            [ProxyManager sharedManager].videoVC = self.testAppViewController;
            [ProxyManager sharedManager].videoStreamSettings = self.videoStreamSettings;

            [[ProxyManager sharedManager] startProxyTCP:tcpConfig];
        } break;
        case ProxyStateSearchingForConnection: {
            [[ProxyManager sharedManager] stopConnection];
        } break;
        case ProxyStateConnected: {
            [[ProxyManager sharedManager] stopConnection];
        } break;
        default: break;
    }
}

- (UIViewController<SDLStreamingMediaDelegate>*)createTestViewControllerOfType:(AppKind)appKind {
    switch (appKind) {
        case AppKindVideoApp:
            return nil;

        case AppKindSimple: // Video Player
            return [SimpleAppViewController createViewController];

        case AppKind3DApp: // 3D app
            return [GameViewController createViewController];

        default:
        case AppKindUIApp: // UI app
            return [TestUIAppViewController createViewController];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return;
    }
    
    switch (indexPath.row) {
        case 0: {
            [self.ipAddressTextField becomeFirstResponder];
        } break;
        case 1: {
            [self.portTextField becomeFirstResponder];
        } break;
        default: break;
    }
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(state))]) {
        ProxyState newState = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self proxyManagerDidChangeState:newState];
        });
    }
}

- (void)proxyManagerDidChangeState:(ProxyState)newState {
    UIColor* newColor = nil;
    NSString* newTitle = nil;
    
    switch (newState) {
        case ProxyStateStopped: {
            newColor = [UIColor redColor];
            newTitle = @"Connect";
            [self finishApp];
        } break;
        case ProxyStateSearchingForConnection: {
            newColor = [UIColor blueColor];
            newTitle = @"Stop Searching";
        } break;
        case ProxyStateConnected: {
            newColor = [UIColor greenColor];
            newTitle = @"Disconnect";
            [self startAppOfKind:self.appKind];
        } break;
        default: break;
    }
    
    if (newColor || newTitle) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.connectTableViewCell setBackgroundColor:newColor];
            [self.connectButton setTitle:newTitle forState:UIControlStateNormal];
        });
    }
}

// start / stop client app

- (void)startAppOfKind:(AppKind)kind {
    NSLog(@"start AppKind:%d", (int)kind);
    if (self.testAppViewController) {
        if ([self.testAppViewController isKindOfClass:[SimpleAppViewController class]]) {
            NSLog(@"%@ : is not supposed to be in the view stack", NSStringFromClass(self.testAppViewController.class));
        } else {
            [self.navigationController pushViewController:self.testAppViewController animated:YES];
        }
    } else {
        NSLog(@"wrong app kind: %d", (int)kind);
    }
}

- (void)finishApp {
    if (self.testAppViewController) {
        [self.navigationController popToViewController:self.parentViewController animated:YES];
    }
}

@end
