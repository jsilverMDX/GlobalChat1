//
//  LoginViewController.h
//  GlobalChatGhost
//
//  Created by DFT User on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *handle_text;
- (IBAction)signIn:(id)sender;

@end
