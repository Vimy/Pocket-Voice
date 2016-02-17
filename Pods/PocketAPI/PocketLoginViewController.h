//
//  PocketLoginViewController.h
//  Pods
//
//  Created by Matthias Vermeulen on 17/02/16.
//
//

#import <UIKit/UIKit.h>

@interface PocketLoginViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) NSString *url;
- (IBAction)cancelClicked:(id)sender;
@end
