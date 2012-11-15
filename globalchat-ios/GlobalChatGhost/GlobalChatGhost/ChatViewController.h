//
//  ChatViewController.h
//  GlobalChatGhost
//
//  Created by DFT User on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *handles_list;
@property (weak, nonatomic) IBOutlet UITextView *chat_buffer;
@property (weak, nonatomic) IBOutlet UITextField *chat_message;
- (IBAction)sendMessage:(id)sender;

@end
