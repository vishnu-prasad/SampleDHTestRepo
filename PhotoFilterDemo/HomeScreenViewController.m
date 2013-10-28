//
//  HomeScreenViewController.m
//  SnapShare
//
//  Created by Digital Horizons Mac 1 on 15/03/13.
//  Copyright (c) 2013 Digital Horizons Mac 1. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "ImageViewController.h"

@interface HomeScreenViewController ()
{
    ImageViewController *secView;
}
@end

@implementation HomeScreenViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      // Do any additional setup after loading the view from its nib.
}
-(void)SettingForLandScapeMode
{
    [imageForLogo setFrame:CGRectMake(125, 30, 204, 73)];
    
    [buttonForCemra setFrame:CGRectMake(50, 180, 180, 100)];
    [buttonForShare setFrame:CGRectMake(260, 175, 180, 100)];
}

-(void)SettingForPortraitMode
{
    [imageForLogo setFrame:CGRectMake(58, 42, 204, 73)];
    
    [buttonForCemra setFrame:CGRectMake(20, 190, 180, 100)];
    [buttonForShare setFrame:CGRectMake(123, 310, 174, 100)];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    
    if(toInterfaceOrientation == 1 || toInterfaceOrientation  == 2)
    {
        [self SettingForPortraitMode];
    }
    else if(toInterfaceOrientation == 3 || toInterfaceOrientation == 4)
    {
        [self SettingForLandScapeMode];
    }
    
    NSLog(@"%d",toInterfaceOrientation);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == 1 || interfaceOrientation  == 2)
    {
        [self SettingForPortraitMode];
    }
    else if(interfaceOrientation == 3 || interfaceOrientation == 4)
    {
        [self SettingForLandScapeMode];
    }
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    m_Orientation =[UIDevice currentDevice].orientation;
    if(m_Orientation == 1 || m_Orientation  == 2)
    {
        [self SettingForPortraitMode];
    }
    else if(m_Orientation == 3 || m_Orientation == 4)
    {
        [self SettingForLandScapeMode];
    }
}

-(IBAction)shareButtonClicked
{
    UIImagePickerController *pickerFirLibrary=[[UIImagePickerController alloc] init];
    
    pickerFirLibrary.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    pickerFirLibrary.delegate=self;
    [self presentViewController:pickerFirLibrary animated:YES completion:nil];
}
-(IBAction)cemraButtonClicked
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *objPicker = [[UIImagePickerController alloc] init];
        objPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        objPicker.delegate = self;
        [self presentViewController:objPicker animated:YES completion:nil];
    }
    
    else{
        UIAlertView *alertForCemra= [[UIAlertView alloc] initWithTitle:@"Snap Share" message:@"Cemra Device is not Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertForCemra show];
    }

}
#pragma mark - UIIAGEPICKERCONTROLLER DELEGATE
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    secView=nil;
    if(secView == nil)
    {
        secView = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:[NSBundle mainBundle]];
    }
    secView.theImage = image;
       [picker pushViewController:secView animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadImageViewControllerWithImage:(UIImage *)image
{
    secView.theImage = image;
    [self presentViewController:secView animated:YES completion:nil];
}
@end
