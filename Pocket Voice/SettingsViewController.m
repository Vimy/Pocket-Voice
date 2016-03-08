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
#import "Pocket_Voice-Swift.h"
#import "Colors.h"


@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *voicesPickerView;
@property (strong, nonatomic) IBOutlet UITableViewCell *logoutCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *supportCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *creditsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *librariesCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *voiceSelectCell;
@property (strong, nonatomic) IBOutlet UILabel *selectedVoiceLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *voicePickerCell;

@property (strong, nonatomic) NSDictionary *voicesDic;
@property (strong, nonatomic) NSArray *pickerVoicesArray;
@property (strong, nonatomic) WatsonTTSManager *manager;
@property  BOOL datePickerIsVisible;
@property (strong, nonatomic) IBOutlet UIButton *setVoiceButton;
@property (strong, nonatomic) IBOutlet UILabel *selectVoiceLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.voicesPickerView.delegate = self;
    self.voicesPickerView.dataSource = self;
    
    self.manager = [WatsonTTSManager sharedInstance];
    
    self.voicesDic = @{@"Kate (GB)":@"en-GB_KateVoice", @"Allison (US)":@"en-US_AllisonVoice", @"Lisa (US)":@"en-US_LisaVoice"};
    self.tableView.backgroundColor = [UIColor hex:@"#282c37"];
    //self.tableView.backgroundColor = [UIColor hex:@"#282c37"];
   
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
//  self.voicesArray = @[@{@"Kate (GB)":@"en-GB_KateVoice"},@{@"Allison (US)":@"en-US_AllisonVoice"},@{@"Lisa (US)":@"en-US_LisaVoice"}];
    
    self.navigationController.title = @"Settings";
    
    self.pickerVoicesArray = @[@"Kate (GB)", @"Allison (US)", @"Lisa (US)"];

    self.datePickerIsVisible = NO;
    self.selectVoiceLabel.textColor = [UIColor hex:@"#9baec8"];
    
    self.selectedVoiceLabel.textColor = [UIColor hex:@"#d9e1e8"];
    
    self.voicesPickerView.backgroundColor = [UIColor hex:@"#282c37"];
    
    self.setVoiceButton.titleLabel.textColor = [UIColor hex:@"#d9e1e8"];
    
    self.voicePickerCell.backgroundColor = [UIColor hex:@"#282c37"];
    self.logoutCell.backgroundColor = [UIColor hex:@"#282c37"];
    self.supportCell.backgroundColor = [UIColor hex:@"#282c37"];
    self.creditsCell.backgroundColor = [UIColor hex:@"#282c37"];
    self.librariesCell.backgroundColor = [UIColor hex:@"#282c37"];
    self.voiceSelectCell.backgroundColor = [UIColor hex:@"#282c37"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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
        
        ActivityViewController *logoutMeldingController = [[ActivityViewController alloc]initWithMessage:@"Logging out.."];
        [self presentViewController:logoutMeldingController animated:true completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            appDelegateTemp.window.rootViewController = rootController;
        });
        
       // UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        
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
    self.selectedVoiceLabel.text = selectedVoiceValue;
    self.manager.voiceName = selectedVoice;
    self.datePickerIsVisible = NO;
    [self animateExpandedCell];
}



#pragma mark tableview

//-(void)tableView:(UITableView *)tableView willDisplayCell:
//(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//-(void)viewDidLayoutSubviews
//{
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
//    {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
//    {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
   // UIView *selectedBackgroundView = [[UIView alloc] init];

  //  cell.backgroundColor = [UIColor hex:@"#d9e1e8"];
    cell.textLabel.textColor = [UIColor hex:@"#9baec8"];
    return cell;
}

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
    else if (tappedCell == self.voiceSelectCell)
    {
        self.datePickerIsVisible = YES;
        [self animateExpandedCell];
    }
    else if (tappedCell == self.supportCell)
    {
        [self showMailViewController];
    }
    
}

- (void)showMailViewController
{
    
    

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@""];
        [mail setMessageBody:@"" isHTML:NO];
        [mail setToRecipients:@[@"mathiasv@noizystudios.net"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) { // this is my picker cell
        if (self.datePickerIsVisible) {
            return 249;
        } else {
            return 0;
        }
    } else {
        return self.tableView.rowHeight;
    }
}

- (void)animateExpandedCell
{
    [UIView animateWithDuration:.6 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];

}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Set the text color of our header/footer text.
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor hex:@"#d9e1e8"]];
    
    // Set the background color of our header/footer.
  
    
    // You can also do this to set the background color of our header/footer,
    //    but the gradients/other effects will be retained.
    // view.tintColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.textLabel.textColor = [UIColor hex:@"#d9e1e8"];
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

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [self.pickerVoicesArray objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor hex:@"#9baec8"]}];
    
    return attString;
    
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
