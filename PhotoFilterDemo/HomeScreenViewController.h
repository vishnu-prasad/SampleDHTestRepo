//
//  HomeScreenViewController.h
//  SnapShare
//
//  Created by Digital Horizons Mac 1 on 15/03/13.
//  Copyright (c) 2013 Digital Horizons Mac 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewController.h"

@interface HomeScreenViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIImageView *imageForLogo;
    
    IBOutlet UIButton *buttonForCemra;
    IBOutlet UIButton *buttonForShare;
    
    NSInteger m_Orientation;
}
-(IBAction)shareButtonClicked;
-(IBAction)cemraButtonClicked;
@end
