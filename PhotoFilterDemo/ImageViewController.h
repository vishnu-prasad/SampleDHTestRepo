//
//  ImageViewController.h
//  SnapShare
//
//  Created by Digital Horizons Mac 1 on 18/03/13.
//  Copyright (c) 2013 Digital Horizons Mac 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "BFCropInterface.h"
//Vishnu Added for Facebook integration starts
#define FB_DISP_NAME         @"ShareSnaps"
#define FB_SHARE_CAPTION     @""
#define FB_SHARE_DESCRIPTION @""
//Vishnu Added for Facebook integratin ends 20th August


@interface ImageViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UILabel *labelForName;
    IBOutlet UILabel *labelForDescription;
    IBOutlet UILabel *labelForLocation;
    
    IBOutlet UITextField *textForName;
    IBOutlet UITextField *textForDescription;
    IBOutlet UITextField *textForLocation;
    
    IBOutlet UIImageView *imageViewForEditing;
    UIImage *theImage;
    
    IBOutlet UIView *mView_Stting;
    // For Brightness
    IBOutlet UIView *mView_Stting1;
    // For Rotation
    IBOutlet UIView *mView_Stting2;
 
    IBOutlet UIButton *mButton_Crop;
    
    // For RGB Color
    IBOutlet UIButton *buttonForClose;
    // For Brightness
     IBOutlet UIButton *buttonForClose1;
    // For rotation
    IBOutlet UIButton *buttonForClose2;
    
    NSMutableArray *arrayForSaveData;
    
  
    IBOutlet UIButton *mButton_Cancle;
    
    GPUImageFilter *selectedFilter;
    NSInteger mButtonIndex;
    
   // Navigation Bar
   IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIBarButtonItem *barButtonForBack;
    IBOutlet UIBarButtonItem *barButtonForSave;
    // Temp checking for brightness
    NSMutableArray *arrayLayerFilter;
    CIImage *beginImage;
    
}
//Cropping
@property (nonatomic, strong) IBOutlet UIImageView *displayImage;
@property (nonatomic, strong) BFCropInterface *cropper;
- (IBAction)cropPressed:(id)sender;
- (IBAction)originalPressed:(id)sender;


@property (nonatomic, retain) IBOutlet UIImageView *imageViewForEditing;
@property (nonatomic, retain) UIImage *theImage;
@property (nonatomic, retain) NSMutableArray *arrayForSaveData;
// For Image Coloring
@property (strong, nonatomic) CIImage *beginImage;
@property (strong, nonatomic) IBOutlet UISlider *sliderForBrightness;
@property (strong, nonatomic) IBOutlet UISlider *sliderForRGBColor;
@property (strong, nonatomic) IBOutlet UISlider *sliderForRotation;

// For Coloring
- (IBAction)brightnessSliderValueChanged:(id)sender;
- (IBAction)rgbSliderValueChanged:(id)sender;
- (IBAction)rotationSliderValueChanged:(id)sender;

//-(IBAction)SliderValueChange:(id)sender;
-(IBAction)shareButtonClicked;
-(IBAction)backButtonClicked;
-(void)setImage:(UIImage *)image;

- (IBAction)applyImageFilter:(id)sender;
// For RGB Color
-(IBAction)closeButtonClicked:(id)sender;
// For Brightness
-(IBAction)closeButtonClicked1:(id)sender;
// For Rotation
-(IBAction)closeButtonClicked2:(id)sender;

//Vishnu Changes For Facebook Starts
//Vishnu Changes For Facebook Ends 19th August
@end

