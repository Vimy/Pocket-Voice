//
//  LoginViewController.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 28/09/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import "LoginViewController.h"
#import <PocketAPI.h>


@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (nonatomic, copy) void (^loggedInHandler)(void);

@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
       
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    [[PocketAPI sharedAPI] loginWithHandler:^(PocketAPI *api, NSError *error)
    {
        NSLog(@"Hoera!");
        
        
        
        
        

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
