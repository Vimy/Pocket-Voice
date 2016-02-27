//
//  LoginViewController.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 28/09/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import "LoginViewController.h"
#import "PocketAPI.h"
#import "Pocket_Voice-Swift.h" //hue color

@interface LoginViewController () <SFSafariViewControllerDelegate>

@property (nonatomic, copy) void (^loggedInHandler)(void);

@end

@implementation LoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSafariViewController:)
                                                 name:@"pocketLoginSafarisNeeded"
                                               object:nil];
    self.view.backgroundColor = [UIColor hex: @"#2b90d9"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSafariViewController:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *urlString = dic[@"url"];
    NSLog(@"url :%@", notification);
    SFSafariViewController *safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"https://getpocket.com/auth/authorize?request_token=211eb0e8-f65a-5032-847e-1c1bdc&redirect_uri=pocketapp46280%3AauthorizationFinished"] entersReaderIfAvailable:NO];
        safariVC.delegate = self;
        UIViewController *frontViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (frontViewController.presentedViewController)
        {
            frontViewController = frontViewController.presentedViewController;
        }
    
        [frontViewController presentViewController:safariVC animated:YES completion:nil];
}
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    
    
    //SFSafariViewController *safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"https://getpocket.com/auth/authorize?request_token=211eb0e8-f65a-5032-847e-1c1bdc&redirect_uri=pocketapp46280%3AauthorizationFinished"] entersReaderIfAvailable:NO];
//    
//                SFSafariViewController *safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://www.google.be"] entersReaderIfAvailable:NO];
//    safariVC.delegate = self;
//    UIViewController *frontViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    if (frontViewController.presentedViewController)
//    {
//        frontViewController = frontViewController.presentedViewController;
//    }
//    
//    [frontViewController presentViewController:safariVC animated:YES completion:nil];

    
        [[PocketAPI sharedAPI] loginWithHandler:^(PocketAPI *api, NSError *error){
            if (error)
            {
                NSLog(@"Dit is de mogelijke error: %@",[error userInfo]);
            }
        }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
