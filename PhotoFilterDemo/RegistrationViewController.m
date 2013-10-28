//
//  RegistrationViewController.m
//  SnapShare
//
//  Created by Digital Horizons Mac 1 on 15/03/13.
//  Copyright (c) 2013 Digital Horizons Mac 1. All rights reserved.
//

#import "RegistrationViewController.h"
#import "HomeScreenViewController.h"
#import "LoginViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if( [UIScreen mainScreen].bounds.size.height == 568)
    {
        [self.view setFrame:CGRectMake(0, 0, 320, 548)];
    }else{
        [self.view setFrame:CGRectMake(0, 0, 320, 460)];
    }
    // Do any additional setup after loading the view from its nib.
    scrollView.contentSize = CGSizeMake(320, self.view.frame.size.height);
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [textForFirstName resignFirstResponder];
    [textForLastName resignFirstResponder];
    [textForMailId resignFirstResponder];
    [textForMobileNo resignFirstResponder];
}
-(void)SettingForLandScapeMode
{
    [scrollView setFrame:CGRectMake(0, 0, 568, 320)];
    scrollView.contentSize = CGSizeMake(568, 415);
    
    [imageForLogo setFrame:CGRectMake(125, 30, 204, 73)];
    
    [labelForFirstname setFrame:CGRectMake(16, 158, 100, 30)];
    [labelForLastName setFrame:CGRectMake(16, 202, 100, 30)];
    [labelForMailId setFrame:CGRectMake(16, 246, 74, 30)];
    [labelForMobileNo setFrame:CGRectMake(16, 290, 74, 30)];
    
    [textForFirstName setFrame:CGRectMake(130, 158, 300, 30)];
    [textForLastName setFrame:CGRectMake(130, 202, 300, 30)];
    [textForMailId setFrame:CGRectMake(130, 246, 300, 30)];
    [textForMobileNo setFrame:CGRectMake(130, 290, 300, 30)];
    
    [buttonForCancel setFrame:CGRectMake(142, 351, 80, 35)];
    [buttonForCreate setFrame:CGRectMake(262, 351, 80, 35)];
}

-(void)SettingForPortraitMode
{
    [scrollView setFrame:CGRectMake(0, 0, 320, 568)];
    scrollView.contentSize = CGSizeMake(320, 568);

    [imageForLogo setFrame:CGRectMake(58, 42, 204, 73)];
    
    [labelForFirstname setFrame:CGRectMake(16, 158, 100, 30)];
    [labelForLastName setFrame:CGRectMake(16, 202, 100, 30)];
    [labelForMailId setFrame:CGRectMake(16, 246, 74, 30)];
    [labelForMobileNo setFrame:CGRectMake(16, 290, 74, 30)];
    
    [textForFirstName setFrame:CGRectMake(123, 158, 187, 30)];
    [textForLastName setFrame:CGRectMake(123, 202, 187, 30)];
    [textForMailId setFrame:CGRectMake(123, 246, 187, 30)];
    [textForMobileNo setFrame:CGRectMake(123, 290, 187, 30)];
    
    [buttonForCancel setFrame:CGRectMake(70, 362, 80, 35)];
    [buttonForCreate setFrame:CGRectMake(176, 362, 80, 35)];

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
    if ([self checkFieldsSignUp]) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",textForFirstName.text,textForLastName.text];
        [userDefault setObject:fullName forKey:@"Full Name"];
        [userDefault setObject:textForMobileNo.text forKey:@"Mobile"];
        [userDefault setObject:textForMailId.text forKey:@"EmailId"];
        if([userDefault synchronize])
        {
            HomeScreenViewController *homeScreenViewController =[[HomeScreenViewController alloc] init];
            [self presentViewController:homeScreenViewController animated:YES completion:nil];
        }
    } else
        [RegistrationViewController showAlertViewWithTitle:@" Share Snaps" message:[NSString stringWithFormat:@"Please fill all the input fields and try again."] delegate:self];
}
-(IBAction)cancelButtonClicked:(id)sender
{
    [self performSelector:@selector(clearFields)];
    //LoginViewController *login =[[LoginViewController alloc] init];
        [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLCONNECTION DELEGATE
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didReceiveResponse, %@", error);
}

//-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    NSLog(@"didReceiveData, %@", data);
//}
//
//-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"didReceiveResponse, %@", response);
//}
//
//-(void) connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    
//}

#pragma mark - TEXTFIELD DELEGATE
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Limiting only the phone number text length
    if ([textField isEqual:textForMobileNo]) {
        return textField.text.length + string.length - range.length<=APP_MOBILE_NUMBER_LENGTH?YES:NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
//    [textField becomeFirstResponder];
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y-100, scrollView.frame.size.width, scrollView.frame.size.height);
}
- (void)textFieldDidEndEditing:(UITextField *)textField             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y+100, scrollView.frame.size.width, scrollView.frame.size.height);
    NSString *messageString = @"Please Enter A Valid";
    if (([textField.placeholder isEqualToString:@"Email Id"] && ![RegistrationViewController validateEmail:textField.text]) || ([textField.placeholder hasSuffix:@"Name"] && ![RegistrationViewController validateName:textField.text]) || ([textField.placeholder isEqualToString:@"Mobile No."] && [textField.text length]!=APP_MOBILE_NUMBER_LENGTH)) {
        
        [RegistrationViewController showAlertViewWithTitle:@"Share Snaps" message:[NSString stringWithFormat:@"%@ %@.",messageString,textField.placeholder] delegate:self];
        //textField.text = @"";
    }
    [textField resignFirstResponder];
}

-(BOOL) textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

+ (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(void) showAlertViewWithTitle:(NSString *) title message:(NSString *) message delegate:(id) delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title message: message delegate: delegate cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [alertView show];
}

+(BOOL) validateName:(NSString *) name
{
    NSString *emailRegEx = @"[a-zA-Z]+";
    
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:name];
    
    return myStringMatchesRegEx;
}

-(BOOL)checkFieldsSignUp
{
    if([[textForFirstName.text stringByReplacingOccurrencesOfString:@" " withString:@""]length]>0 && [[textForLastName.text stringByReplacingOccurrencesOfString:@" " withString:@""]length]>0 && [[textForMailId.text stringByReplacingOccurrencesOfString:@" " withString:@""]length]>0 && [[textForMobileNo.text stringByReplacingOccurrencesOfString:@" " withString:@""]length]==10)
		return YES;
	return NO;
}

-(void) clearFields
{
    textForMailId.text=@"";
    textForFirstName.text=@"";
    textForLastName.text=@"";
    textForMobileNo.text=@"";
}

@end