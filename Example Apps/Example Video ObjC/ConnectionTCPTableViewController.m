//
//  ConnectionTCPTableViewController.m
//  SmartDeviceLink-iOS

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ConnectionTCPTableViewController.h"
#import "Preferences.h"
#import "ProxyManager.h"
#import "SDLStreamingMediaManager.h"
#import "SDLManager.h"
#import "SDLStreamingMediaDelegate.h"
#import "SDLTCPConfig.h"
#import "VideoSourceViewController.h"
#import "VideoStreamSettings.h"


@interface ConnectionTCPTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@property (weak, nonatomic) IBOutlet UITableViewCell *connectTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *appSelector;

@property (strong, nonatomic, nullable) VideoSourceViewController *videoSourceViewController;

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
            [self startProxy];
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
            [self presentVideoApp];
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

- (void)startProxy {
    SDLTCPConfig *tcpConfig = [SDLTCPConfig configWithHost:self.ipAddressTextField.text port:self.portTextField.text.integerValue];

    if (!self.videoSourceViewController) {
        self.videoSourceViewController = [VideoSourceViewController createInstance];
    }
    ProxyManager *proxy = [ProxyManager sharedManager];
    proxy.videoSourceViewController = self.videoSourceViewController;
    proxy.videoStreamSettings = self.videoStreamSettings;

    [proxy startProxyTCP:tcpConfig];
}

// start & show / stop & hide video app

- (void)presentVideoApp {
    [self.navigationController pushViewController:self.videoSourceViewController animated:YES];
}

- (void)finishApp {
    if (self.videoSourceViewController) {
        [self.navigationController popToViewController:self.parentViewController animated:YES];
    }
}

@end
