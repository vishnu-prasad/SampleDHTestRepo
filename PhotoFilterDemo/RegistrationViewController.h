//
//  RegistrationViewController.h
//  SnapShare
//
//  Created by Digital Horizons Mac 1 on 15/03/13.
//  Copyright (c) 2013 Digital Horizons Mac 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIImageView *imageForLogo;
    
    IBOutlet UILabel *labelForFirstname;
    IBOutlet UILabel *labelForLastName;
    IBOutlet UILabel *labelForMailId;
    IBOutlet UILabel *labelForMobileNo;
    
    IBOutlet UITextField *textForFirstName;
    IBOutlet UITextField *textForLastName;
    IBOutlet UITextField *textForMailId;
    IBOutlet UITextField *textForMobileNo;
    
    IBOutlet UIButton *buttonForCreate;
    IBOutlet UIButton *buttonForCancel;
    
    IBOutlet UIScrollView *scrollView;
    
     NSInteger m_Orientation;
    NSInteger x;
}
-(IBAction)createButtonClicked:(id)sender;
-(IBAction)cancelButtonClicked:(id)sender;

@end
