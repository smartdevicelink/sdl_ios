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
#import "VideoTestViewController.h"
#import "SDLManager.h"

@interface ConnectionTCPTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ipAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@property (weak, nonatomic) IBOutlet UITableViewCell *connectTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@property (strong, nonatomic, nullable) AVPlayer *player;

@property (strong, nonatomic, nullable) VideoTestViewController * testPlayViewController;

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
//            UIViewController *videoVC = [self createVideoVC];

            if (self.testPlayViewController) {
                [self.navigationController popToViewController:self.parentViewController animated:YES];
                self.testPlayViewController = nil;
            }
            self.testPlayViewController = [VideoTestViewController createViewController];
            [ProxyManager sharedManager].videoVC = self.testPlayViewController;

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

- (IBAction)playVideoActionStart:(id)sender {
    NSLog(@"Play");
    if (self.player) { [self.player play]; }
    else { NSLog(@"no player, skip play");}

    if (!self.testPlayViewController) {
        self.testPlayViewController = [VideoTestViewController createViewController];
    }
    [self.navigationController pushViewController:self.testPlayViewController animated:YES];
    [self.testPlayViewController startAnime];
}

- (IBAction)playVideoActionStop:(id)sender {
    NSLog(@"Play-stop");
    if (self.player) { [self.player pause]; }
    else { NSLog(@"no player, skip pause");}

    if (self.testPlayViewController) {
        [self.navigationController popToViewController:self.parentViewController animated:YES];
//        self.testPlayViewController = nil;
    }
}

- (IBAction)resumeStreaming:(id)sender {
    [[ProxyManager sharedManager].sdlManager resumeStreaming];
}

- (IBAction)suspendStreaming:(id)sender {
    [[ProxyManager sharedManager].sdlManager suspendStreaming];
}

- (UIViewController*)createVideoVC {
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"sdl_video" withExtension:@"mp4"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:[videoURL path]]) {
        NSLog(@"no video at: %@", videoURL);
        return nil;
    }

    if (self.player) {
        [self.player pause];
        self.player = nil;
    }
    self.player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = self.player;
    return playerViewController;


    [self presentViewController:playerViewController animated:YES completion:^{
      [playerViewController.player play];
    }];
    return playerViewController;
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
    UIColor* newColor = nil;
    NSString* newTitle = nil;
    
    switch (newState) {
        case ProxyStateStopped: {
            newColor = [UIColor redColor];
            newTitle = @"Connect";
        } break;
        case ProxyStateSearchingForConnection: {
            newColor = [UIColor blueColor];
            newTitle = @"Stop Searching";
        } break;
        case ProxyStateConnected: {
            newColor = [UIColor greenColor];
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
