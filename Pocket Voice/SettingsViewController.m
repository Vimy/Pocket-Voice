//
//  SettingsViewController.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 16/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "Pocket_Voice-Swift.h"
#import "VTAcknowledgementsViewController.h"


@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *voicesPickerView;
@property (strong, nonatomic) IBOutlet UITableViewCell *logoutCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *supportCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *creditsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *librariesCell;
@property (strong, nonatomic) NSDictionary *voicesDic;
@property (strong, nonatomic) NSArray *pickerVoicesArray;
@property (strong, nonatomic) WatsonTTSManager *manager;


@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.voicesPickerView.delegate = self;
    self.voicesPickerView.dataSource = self;
    
    self.manager = [WatsonTTSManager sharedInstance];
    
    self.voicesDic = @{@"Kate (GB)":@"en-GB_KateVoice", @"Allison (US)":@"en-US_AllisonVoice", @"Lisa (US)":@"en-US_LisaVoice"};
    
    
//    self.voicesArray = @[@{@"Kate (GB)":@"en-GB_KateVoice"},@{@"Allison (US)":@"en-US_AllisonVoice"},@{@"Lisa (US)":@"en-US_LisaVoice"}];
    self.pickerVoicesArray = @[@"Kate (GB)", @"Allison (US)", @"Lisa (US)"];

 //   http://www.appcoda.com/expandable-table-view/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)logout
{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[PocketAPI sharedAPI]logout];
        
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"loginVC"];
        
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        appDelegateTemp.window.rootViewController = navigation;
    }]];
    

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self closeAlertview];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
      
}

-(void)closeAlertview
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)showLibrariesViewController
{
    VTAcknowledgementsViewController *viewController = [VTAcknowledgementsViewController acknowledgementsViewController];
    viewController.headerText = NSLocalizedString(@"We love open source software.", nil); // optional
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)setVoicesFromPickerView:(UIButton *)sender
{
    NSString *selectedVoiceValue = [self.voicesPickerView.delegate pickerView:
                                    self.voicesPickerView titleForRow:
                                    [self.voicesPickerView selectedRowInComponent:0] forComponent:1];
    
    NSString *selectedVoice = [self.voicesDic valueForKey:selectedVoiceValue];
    self.manager.voiceName = selectedVoice;

}



#pragma mark tableview

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tappedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (tappedCell == self.logoutCell)
    {
        [self logout];
    }
    else if (tappedCell == self.librariesCell)
    {
        [self showLibrariesViewController];
    }
    
}

#pragma mark UIPickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerVoicesArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = [self.pickerVoicesArray objectAtIndex:row];
    NSLog(@"Looogggieee:%@", [self.pickerVoicesArray objectAtIndex:row]);
    return string;
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
