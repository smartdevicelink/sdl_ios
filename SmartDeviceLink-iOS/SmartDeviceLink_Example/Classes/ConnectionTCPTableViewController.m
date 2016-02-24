//
//  ConnectionTCPTableViewController.m
//  SmartDeviceLink-iOS

@import AVFoundation;

#import "ConnectionTCPTableViewController.h"

#import "Preferences.h"
#import "ProxyManager.h"
#import "SDLStreamingMediaManager.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface ConnectionTCPTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@property (weak, nonatomic) IBOutlet UITableViewCell *connectTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end



@implementation ConnectionTCPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Observe Proxy Manager state
    [[ProxyManager sharedManager] addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:nil];
    
    // Tableview setup
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.ipAddressTextField.text = [Preferences sharedPreferences].ipAddress;
    self.portTextField.text = [Preferences sharedPreferences].port;
    
    // Connect Button setup
    self.connectButton.tintColor = [UIColor whiteColor];
}

- (void)dealloc {
    @try {
        [[ProxyManager sharedManager] removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
    } @catch (NSException __unused *exception) {}
}

- (void)didReceiveMemoryWarning {
    NSLog(@"***** MEMORY WARNING *****");
}


#pragma mark - IBActions

- (IBAction)connectButtonWasPressed:(UIButton *)sender {
    [Preferences sharedPreferences].ipAddress = self.ipAddressTextField.text;
    [Preferences sharedPreferences].port = self.portTextField.text;
    
    ProxyState state = [ProxyManager sharedManager].state;
    switch (state) {
        case ProxyStateStopped: {
            [[ProxyManager sharedManager] startProxyWithTransportType:ProxyTransportTypeTCP];
        } break;
        case ProxyStateSearchingForConnection: {
            [[ProxyManager sharedManager] stopProxy];
        } break;
        case ProxyStateConnected: {
            [[ProxyManager sharedManager] stopProxy];
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
        [self proxyManagerDidChangeState:newState];
    }
}

- (void)proxyManagerDidChangeState:(ProxyState)newState {
    switch (newState) {
        case ProxyStateStopped: {
            self.connectTableViewCell.backgroundColor = [UIColor redColor];
            self.connectButton.titleLabel.text = @"Connect";
        } break;
        case ProxyStateSearchingForConnection: {
            self.connectTableViewCell.backgroundColor = [UIColor blueColor];
            self.connectButton.titleLabel.text = @"Stop Searching";
        } break;
        case ProxyStateConnected: {
            self.connectTableViewCell.backgroundColor = [UIColor greenColor];
            self.connectButton.titleLabel.text = @"Disconnect";
        } break;
        default: break;
    }
}

@end
