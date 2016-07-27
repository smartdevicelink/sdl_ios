//
//  ConnectionIAPTableViewController.m
//  SmartDeviceLink-iOS

#import "ConnectionIAPTableViewController.h"

#import "ProxyManager.h"



@interface ConnectionIAPTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *connectTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end



@implementation ConnectionIAPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Observe Proxy Manager state
    [[ProxyManager sharedManager] addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:nil];
    
    // Tableview setup
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
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
    ProxyState state = [ProxyManager sharedManager].state;
    switch (state) {
        case ProxyStateStopped: {
            [[ProxyManager sharedManager] startProxyWithTransportType:ProxyTransportTypeIAP];
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


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(state))]) {
        ProxyState newState = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        [self proxyManagerDidChangeState:newState];
    }
}


#pragma mark - Private Methods

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
