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
    if (@available(iOS 11.0, *)) {
        self.tableView.dragInteractionEnabled = NO;
    }
    self.title = @"iAP";
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
            [[ProxyManager sharedManager] startWithProxyTransportType:ProxyTransportTypeIAP];
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


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(state))]) {
        ProxyState newState = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        [self proxyManagerDidChangeState:newState];
    }
}


#pragma mark - Private Methods

- (void)proxyManagerDidChangeState:(ProxyState)newState {
    UIColor* newColor = nil;
    NSString* newTitle = nil;

    switch (newState) {
        case ProxyStateStopped: {
            newColor = [UIColor colorWithRed:(255.0 / 255.0) green:(69.0 / 255.0) blue:(58.0 / 255.0) alpha:1.0];
            newTitle = @"Connect";
        } break;
        case ProxyStateSearchingForConnection: {
            newColor = [UIColor colorWithRed:(255.0 / 255.0) green:(159.0 / 255.0) blue:(10.0 / 255.0) alpha:1.0];
            newTitle = @"Stop Searching";
        } break;
        case ProxyStateConnected: {
            newColor = [UIColor colorWithRed:(50.0 / 255.0) green:(215.0 / 255.0) blue:(75.0 / 255.0) alpha:1.0];
            newTitle = @"Disconnect";
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


@end
