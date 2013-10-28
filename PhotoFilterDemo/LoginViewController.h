//
//  ViewController.h
//  SnapShare
//
//  Created by Digital Horizons Mac 1 on 15/03/13.
//  Copyright (c) 2013 Digital Horizons Mac 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UIImageView *imageForLogo;
    IBOutlet UIButton *buttonForCreate;
    NSInteger m_Orientation;
}
-(IBAction)createButtonClicked:(id)sender;

@end
