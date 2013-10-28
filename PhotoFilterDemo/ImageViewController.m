//
//  ImageViewController.m
//  SnapShare
//
//  Created by Digital Horizons Mac 1 on 18/03/13.
//  Copyright (c) 2013 Digital Horizons Mac 1. All rights reserved.
//

#import "ImageViewController.h"
#import "HomeScreenViewController.h"
#import "GPUImage.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <FacebookSDK/FacebookSDK.h>


//Vishnu Changes For Facebook Starts
#import <FacebookSDK/FacebookSDK.h>
//Vishnu Changes For Facebook Ends 19th August


//Vishnu Changes For Twitter Starts
#import <Twitter/Twitter.h>
#define ACTIONSHEET_SHARE_TAG       123546
//Vishnu Changes For Twitter Ends -14th Aug 2013

@interface ImageViewController ()
@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) CIFilter *filter;
@property (strong, nonatomic) CIFilter *filter2;
@property (strong, nonatomic) CIFilter *filter3;

//- (void)logAllFilters;
@end

@implementation ImageViewController

@synthesize imageViewForEditing;
@synthesize arrayForSaveData;
@synthesize theImage;
@synthesize displayImage,cropper;
@synthesize sliderForBrightness;
@synthesize sliderForRGBColor;
@synthesize sliderForRotation;
@synthesize context;
@synthesize filter;
@synthesize filter2;
@synthesize filter3;
@synthesize beginImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidUnload
{
  //  [self setImgV:nil];
    [self setSliderForBrightness:nil];
    self.context = nil;
    self.filter = nil;
    self.filter2 = nil;
    self.filter3 = nil;
    self.beginImage = nil;
    [self setSliderForRGBColor:nil];
    [self setSliderForRotation:nil];
    [super viewDidUnload];
}
- (void)viewDidLoad
{
     [super viewDidLoad];
   // [self logAllFilters];
    
    context = [CIContext contextWithOptions: nil];
    
    filter = [CIFilter filterWithName:@"CISepiaTone"];
    filter2 = [CIFilter filterWithName:@"CIHueAdjust"];
    filter3 = [CIFilter filterWithName:@"CIStraightenFilter"];
    
    self.sliderForBrightness.value = 0.0;
    self.sliderForRGBColor.minimumValue = -3.14;
    self.sliderForRGBColor.maximumValue = 3.14;
    self.sliderForRGBColor.value = 0.0;
    self.sliderForRotation.minimumValue = -3.14;
    self.sliderForRotation.maximumValue = 3.14;
    self.sliderForRotation.value = 0.0;
    self.displayImage.image = self.theImage;    
    
    arrayLayerFilter = [[NSMutableArray alloc] init];
    self.title=@"ShareSnaps";
    
    arrayForSaveData =[[NSMutableArray alloc] init];
    
    // For RGB Color
    [self.view addSubview:mView_Stting];
    [mView_Stting setFrame:CGRectMake(0, 568, 320, 195)];
    // For Brightness
    [self.view addSubview:mView_Stting1];
    [mView_Stting1 setFrame:CGRectMake(0, 568, 320, 195)];
    // For Brightness
    [self.view addSubview:mView_Stting2];
    [mView_Stting2 setFrame:CGRectMake(0, 568, 320, 195)];
    
    self.imageViewForEditing.image=self.theImage;
    if( [UIScreen mainScreen].bounds.size.height == 568)
    {
        [self.view setFrame:CGRectMake(0, 0, 320, 548)];
    }else{
        [self.view setFrame:CGRectMake(0, 0, 320, 460)];
    }
    // Do any additional setup after loading the view from its nib.
    scrollView.contentSize = CGSizeMake(320, self.view.frame.size.height-450);
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
    [[self.navigationController navigationBar] setHidden:YES];
    
    //Cropping Settings
    
    // make your image view content mode == aspect fit
    // yields best results
    self.displayImage.contentMode = UIViewContentModeScaleAspectFit;
    
    // must have user interaction enabled on view that will hold crop interface
    self.displayImage.userInteractionEnabled = YES;
    self.displayImage.frame = CGRectMake(0 , 46, 320, 234);
    //    self.originalImage =self.theImage;
    //    self.displayImage.image = self.originalImage;
    self.displayImage.image = self.theImage;
    [arrayLayerFilter addObject:theImage];
    // ** this is where the magic happens
    
    // allocate crop interface with frame and image being cropped
    self.cropper = [[BFCropInterface alloc]initWithFrame:self.displayImage.bounds andImage:self.displayImage.image];
    // this is the default color even if you don't set it
    self.cropper.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
    // white is the default border color.
    self.cropper.borderColor = [UIColor whiteColor];
    // add interface to superview. here we are covering the main image view.
    [self.displayImage addSubview:self.cropper];
    self.cropper.alpha = 0.0;
    beginImage = [CIImage imageWithCGImage:displayImage.image.CGImage];
    
}

//- (void)logAllFilters {
//    NSArray *properties = [CIFilter filterNamesInCategory:
//                           kCICategoryBuiltIn];
//    NSLog(@"FilterName:\n%@", properties);
//    for (NSString *filterName in properties) {
//        CIFilter *fltr = [CIFilter filterWithName:filterName];
//        NSLog(@"%@:\n%@", filterName, [fltr attributes]);
//    }
//}
//
- (IBAction)brightnessSliderValueChanged:(id)sender
{
    float slideValue = self.sliderForBrightness.value;
    [filter setValue:beginImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputIntensity"];
    

    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    [displayImage setImage:newImg];
    CGImageRelease(cgimg);
}
- (IBAction)rgbSliderValueChanged:(id)sender
{
    float slideValue = self.sliderForRGBColor.value;
    
    [filter2 setValue:[CIImage imageWithCGImage:displayImage.image.CGImage] forKey:kCIInputImageKey];
    [filter2 setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputAngle"];
    
    CIImage *outputImage = [filter2 outputImage];
  
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    [displayImage setImage:newImg];
     CGImageRelease(cgimg);
}

- (IBAction)rotationSliderValueChanged:(id)sender
{
    float slideValue = self.sliderForRotation.value;
    
    [filter3 setValue:beginImage forKey:kCIInputImageKey];
    [filter3 setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputAngle"];
    
    CIImage *outputImage = [filter3 outputImage];
  
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    [displayImage setImage:newImg];   
    CGImageRelease(cgimg);
}

-(BOOL)checkFieldsSignUp
{
    if([[textForName.text stringByReplacingOccurrencesOfString:@" " withString:@""]length]>0 && [[textForLocation.text stringByReplacingOccurrencesOfString:@" " withString:@""]length]>0 && [[textForLocation.text stringByReplacingOccurrencesOfString:@" " withString:@""]length]>0)
        return YES;
    return NO;
}


// FOR Setting RGBColor
-(void)SettingView_Appear
{
    [UIView beginAnimations:nil context:NULL];
    [UIView animateWithDuration:1 animations:nil];
    
    [mView_Stting setFrame:CGRectMake(0,self.view.frame.size.height- 100, 320, 195)];
    
    [UIView commitAnimations];
}
-(void)SettingView_DisAppear
{
    [UIView beginAnimations:nil context:NULL];
    [UIView animateWithDuration:1 animations:nil];
    
    [mView_Stting setFrame:CGRectMake(0, 568, 320, 195)];
    
    [UIView commitAnimations];
}

-(IBAction)closeButtonClicked:(id)sender
{
    buttonForClose.selected = !buttonForClose.selected;
    
    if(buttonForClose.selected)
    {
        [self SettingView_DisAppear];
         [arrayLayerFilter addObject:displayImage.image];
    }
    else
    {
        [self SettingView_DisAppear];
    }
    [arrayLayerFilter addObject:self.displayImage.image];
}

// For Brightness
-(void)SettingView_Appear1
{
    [UIView beginAnimations:nil context:NULL];
    [UIView animateWithDuration:1 animations:nil];
    
    [mView_Stting1 setFrame:CGRectMake(0,self.view.frame.size.height- 100, 320, 195)];
    
    [UIView commitAnimations];
}
-(void)SettingView_DisAppear1
{
    [UIView beginAnimations:nil context:NULL];
    [UIView animateWithDuration:1 animations:nil];
    
    [mView_Stting1 setFrame:CGRectMake(0, 568, 320, 195)];
    
    [UIView commitAnimations];
}

-(IBAction)closeButtonClicked1:(id)sender
{
    buttonForClose1.selected = !buttonForClose1.selected;
    
    if(buttonForClose1.selected)
    {
        [self SettingView_DisAppear1];
    }
    else
    {
        [self SettingView_DisAppear1];
    }
    [arrayLayerFilter addObject:self.displayImage.image];
}
// For Rotation
-(void)SettingView_Appear2
{
    [UIView beginAnimations:nil context:NULL];
    [UIView animateWithDuration:1 animations:nil];
    
    [mView_Stting2 setFrame:CGRectMake(0,self.view.frame.size.height- 100, 320, 195)];
    
    [UIView commitAnimations];
}
-(void)SettingView_DisAppear2
{
    [UIView beginAnimations:nil context:NULL];
    [UIView animateWithDuration:1 animations:nil];
    
    [mView_Stting2 setFrame:CGRectMake(0, 568, 320, 195)];
    
    [UIView commitAnimations];
}

-(IBAction)closeButtonClicked2:(id)sender
{
    buttonForClose2.selected = !buttonForClose2.selected;
    
    if(buttonForClose2.selected)
    {
        [self SettingView_DisAppear2];
    }
    else
    {
        [self SettingView_DisAppear2];
    }
    [arrayLayerFilter addObject:self.displayImage.image];
}



- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [textForName resignFirstResponder];
    [textForDescription resignFirstResponder];
    [textForLocation resignFirstResponder];
}
-(void)setImage:(UIImage *)image
{
    [imageViewForEditing setImage:image];
}
#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 110)
    {
        mButtonIndex = buttonIndex;
        NSLog(@"%d",buttonIndex);
        switch (buttonIndex) {
            case 0: {
                selectedFilter = [[GPUImageLuminanceThresholdFilter alloc] init];
                break;
            }
                
            case 1: {
                selectedFilter = [[GPUImageSepiaFilter alloc] init];
                break;
            }
                
            case 2: {
                selectedFilter = [[GPUImageSketchFilter alloc] init];
                break;
            }
                
            case 3: {
                selectedFilter = [[GPUImageColorInvertFilter alloc] init];
                break;
            }
                
            case 4: {
                selectedFilter = [[GPUImageToonFilter alloc] init];
                break;
            }
                
            case 5: {
                selectedFilter = [[GPUImagePinchDistortionFilter alloc] init];
                break;
            }
                
            case 6: {
                selectedFilter = [[GPUImageErosionFilter alloc] init];
                break;
            }
                
            case 7: {
                selectedFilter = [[GPUImageBoxBlurFilter alloc] init];
                break;
            }
                
            case 8: {
                selectedFilter = [[GPUImageBulgeDistortionFilter alloc] init];
                break;
            }
                
            case 9: {
                [self SettingView_Appear];
                break;
            }
                
            case 10: {
                [self SettingView_Appear1];
                break;
            }
            case 11: {
                [self SettingView_Appear2];
                break;
            }

            case 12: {
                [self.displayImage setImage:(UIImage *)[arrayLayerFilter objectAtIndex:0]];
                return;
            }
                
            default:
                return;
        }
        if(buttonIndex != 9 && buttonIndex != 11 && buttonIndex != 10)
        {
            UIImage *filteredImage = [selectedFilter imageByFilteringImage:self.displayImage.image];
            [self.displayImage setImage:filteredImage];
        }
        
        beginImage = [CIImage imageWithCGImage:displayImage.image.CGImage];
        
        [arrayLayerFilter addObject:(UIImage *)self.displayImage.image];
    }
    else
    {
        mButtonIndex = buttonIndex;
        switch (buttonIndex) {
            case 0:
                
                //Vishnu Changes For Facebook Starts
                [self initiateFacebookSharing];
                //Vishnu Changes For Facebook Ends -19th Aug 2013
                break;
            case 1:
                //Vishnu Changes For Facebook Starts
                [self initiateTwitterRequest];
                //Vishnu Changes For Facebook Ends -19th Aug 2013
                break;
            case 2:
                UIImageWriteToSavedPhotosAlbum(self.displayImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                [self savingDataForFields];
                [self dismissViewControllerAnimated:YES completion:nil];
                
                break;
                
            default:
                return;
                break;
        }
        
    }
}
-(void) initiateTwitterRequest
{
    //Vishnu Changes For Twitter Starts
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    CGFloat version=[iOSVersion floatValue];
    if(version >=6.0)//if the version above 6.0
    {
        
        //if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])//For iOS 6 onwards
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet addImage:self.displayImage.image];
            [tweetSheet setInitialText:[textForDescription text]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
    }else//Doing iOS 5 switching
    {
        //if ([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet =
            [[TWTweetComposeViewController alloc] init];
            [tweetSheet addImage:self.displayImage.image];
            [tweetSheet setInitialText:[textForDescription text]];
            [self presentModalViewController:tweetSheet animated:YES];
        }
    }
    //Vishnu Changes For Twitter Ends -20th Aug 2013
}
- (IBAction)applyImageFilter:(id)sender
{
    UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Filter"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:
                                        @"Black & White",
                                        @"Sepia",
                                        @"Sketch",
                                        @"Color Invert",
                                        @"Toon",
                                        @"Pinch Distort",
                                        @"Lighting",
                                        @"Blur",
                                        @"BulgeDistortion",
                                        @"RGB Color",
                                        @"Brightness",
                                        @"Rotation",
                                        @"None", nil];
    
    filterActionSheet.delegate = self;
    [filterActionSheet setTag:110];
    [filterActionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [filterActionSheet showInView:self.view];
}

#pragma mark - TEXTFIELD DELEGATE

-(BOOL) textFieldShouldReturn:(UITextField *) textField {
    
    if(textField==textForName)
    {
        [textForDescription becomeFirstResponder];
    }else if(textField==textForDescription)
    {
        [textForLocation becomeFirstResponder];
    }//else if(textField==textForLocation)
    //{
    //}
    else
    {
        //do nothing
    }
    [textField resignFirstResponder];
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField          
{
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y-150, scrollView.frame.size.width, scrollView.frame.size.height);
}
- (void)textFieldDidEndEditing:(UITextField *)textField         
{
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y+150, scrollView.frame.size.width, scrollView.frame.size.height);
    NSString *messageString = @"Please Enter A Valid";
    if (([textField.placeholder isEqualToString:@"Location"] && ![ImageViewController validateName:textField.text]) || ([textField.placeholder hasSuffix:@"Name"] && ![ImageViewController validateName:textField.text])) {
        
        [ImageViewController showAlertViewWithTitle:@"Snap Share" message:[NSString stringWithFormat:@"%@ %@.",messageString,textField.placeholder] delegate:self];
        //textField.text = @"";
    }
    [textField resignFirstResponder];
}
-(BOOL) textFieldShouldClear:(UITextField *)textField
{
    return YES;
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
-(void) clearFields
{
    textForName.text=@"";
    textForDescription.text=@"";
    textForLocation.text=@"";
}

- (IBAction)originalPressed:(id)sender
{
    self.cropper.alpha = 0.0;
    mButton_Crop.selected = false;
    [mButton_Crop setEnabled:YES];
    
    if ([arrayLayerFilter count]!=1) {
        [arrayLayerFilter removeLastObject];
    }
    self.displayImage.image = (UIImage *)[arrayLayerFilter lastObject];
    if (!self.cropper)
    {
        self.cropper = [[BFCropInterface alloc]initWithFrame:self.displayImage.bounds andImage:self.displayImage.image];
        [self.cropper setImage:self.displayImage.image];
        [self.displayImage addSubview:self.cropper];
    }
    self.cropper.alpha = 0.0;
}
//Cropping
- (IBAction)cropPressed:(id)sender {
    
    mButton_Crop.selected = !mButton_Crop.selected;
    if(mButton_Crop.selected)
    {
        self.cropper.alpha = 1.0;
        [self.cropper setImage:self.displayImage.image];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ShareSnaps"
                                                        message:@"Adjust the crop window and click the Crop button again!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];

    }else{
        // crop image
        UIImage *croppedImage = [self.cropper getCroppedImage];
        // remove crop interface from superview
        [self.cropper removeFromSuperview];
        self.cropper = nil;
        //    self.originalImage = self.displayImage.image;
        [arrayLayerFilter addObject:self.displayImage.image];
        // display new cropped image
        self.displayImage.image = croppedImage;
        [arrayLayerFilter addObject:self.displayImage.image];
        [mButton_Crop setEnabled:NO];
    }
}

#pragma mark -
#pragma mark UIImagePickerController

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *alertTitle;
    NSString *alertMessage;
    
    if(!error)
    {
        alertTitle   = @"Image Saved";
        alertMessage = @"Image saved to photo album successfully.";
    }
    else
    {
        alertTitle   = @"Error";
        alertMessage = @"Unable to save to photo album.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)shareButtonClicked
{
    if(mButton_Crop.selected)
    {
        [self originalPressed:nil];
    }
    UIActionSheet *actionSheetForShare =[[UIActionSheet alloc] initWithTitle:@"Snap Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter",@"Save to Album", nil ];
    actionSheetForShare.tag=ACTIONSHEET_SHARE_TAG;
    [actionSheetForShare setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [actionSheetForShare showInView:self.view];
}

-(IBAction)backButtonClicked
{
    [self performSelector:@selector(clearFields)];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSUInteger) supportedInterfaceOrientations
{
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait |UIInterfaceOrientationMaskPortraitUpsideDown ;
}
-(BOOL) shouldAutorotate
{
    return YES;
}
-(void) savingDataForFields
{
    NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] initWithObjectsAndKeys:textForName.text,@"Name",textForDescription.text,@"Description",textForLocation.text,@"Location", nil];
    
    if(self.arrayForSaveData.count >0)
    {
        [self.arrayForSaveData removeAllObjects];
        
        self.arrayForSaveData = (NSMutableArray *)[NSMutableArray arrayWithArray:(NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ArrayForFields"]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.arrayForSaveData addObject:(NSMutableArray *)[NSMutableDictionary dictionaryWithDictionary:(NSMutableDictionary*)dictionary]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithArray:(NSMutableArray*) self.arrayForSaveData ] forKey:@"ArrayForFields"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"No of objects = %d and last object = %@",self.arrayForSaveData.count, [self.arrayForSaveData objectAtIndex:self.arrayForSaveData.count-1]);
}
#pragma mark- Facebook integration methods
//Vishnu Changes For Facebook Starts
- (void) initiateFacebookSharing
{
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    CGFloat version=[iOSVersion floatValue];
    if(version >=6.0)//if the version above 6.0
    {
        //if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [controller addImage:self.displayImage.image];
            [controller setInitialText:[textForDescription text]];
            [self presentViewController:controller animated:YES completion:Nil];
        //}
    }else
    {
        // See if the app has a valid token for the current state.
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            // To-do, start FB sharing
            [self processFacebookSharing];
        }else
        {
            //To do , start the FB authentication
            [self initiateFacebookAuthentication];
        }
    }
}
- (void) initiateFacebookAuthentication
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
- (void) processFacebookSharing
{
        // Put together the dialog parameters
        NSMutableDictionary *params =
        [NSMutableDictionary dictionaryWithObjectsAndKeys:
         @"ShareSnaps", @"name",
         @"Build great social apps and get more installs.", @"caption",
         @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
         @"https://developers.facebook.com/ios", @"link",
         @"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png",@"picture",
         nil];
        
        // Invoke the dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:
         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 // Error launching the dialog or publishing a story.
                 NSLog(@"Error publishing story.");
             } else {
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     // User clicked the "x" icon
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // Handle the publish feed callback
                     NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                     if (![urlParams valueForKey:@"post_id"]) {
                         // User clicked the Cancel button
                         NSLog(@"User canceled story publishing.");
                     } else {
                         // User clicked the Share button
                         NSString *msg = [NSString stringWithFormat:
                                          @"Posted story, id: %@",
                                          [urlParams valueForKey:@"post_id"]];
                         NSLog(@"%@", msg);
                         // Show the result in an alert
                         [[[UIAlertView alloc] initWithTitle:@"Result"
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:@"OK!"
                                           otherButtonTitles:nil]
                          show];
                     }
                 }
             }
         }];
    }

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [self processFacebookSharing];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            // Once the user has logged in, we want them to
            // be looking at the root view.
        }
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

//Vishnu Changes For Facebook Ends -19th Aug 2013


@end
