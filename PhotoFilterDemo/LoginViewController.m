//
//  ViewController.m
//  SnapShare
//
//  Created by Digital Horizons Mac 1 on 15/03/13.
//  Copyright (c) 2013 Digital Horizons Mac 1. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidUnload
{
        // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)SettingForLandScapeMode
{
    [imageForLogo setFrame:CGRectMake(125, 30, 204, 73)];
    [buttonForCreate setFrame:CGRectMake(129, 197, 200, 30)];
}

-(void)SettingForPortraitMode
{
    [imageForLogo setFrame:CGRectMake(58, 42, 204, 73)];
    [buttonForCreate setFrame:CGRectMake(49, 249, 200, 30)];
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

-(IBAction)createButtonClicked:(id)sender
{
    RegistrationViewController *registrationViewController=[[RegistrationViewController alloc] init];
    [self presentViewController:registrationViewController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
