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

@property (nonatomic, copy) void (^loggedInHandler)(void);

@end

@implementation LoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSError* errorJSON;
//    NSArray *actions = @[@{ @"count": @"10", @"detailType": @"complete" }];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: actions
//                                                       options: kNilOptions
//                                                         error: &errorJSON];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding: NSUTF8StringEncoding];
//    
//    NSDictionary* argumentDictionary = @{@"actions":jsonString};
//    
//    [[PocketAPI sharedAPI] callAPIMethod:@"get"
//                          withHTTPMethod:PocketAPIHTTPMethodPOST
//                               arguments:argumentDictionary
//                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error){
//                               //      pocketItemsDic = [response copy];
//                                     NSLog(@"response Original %@", [response description]);
//                                 //    NSLog(@"response %@", [pocketItemsDic description]);
//                                     NSLog(@"error %@", [error localizedDescription]);
//                                 }];

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
