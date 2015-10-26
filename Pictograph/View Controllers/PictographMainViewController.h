//
//  ViewController.h
//  Pictograph
//
//  Created by Adam on 2015-09-30.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageCoder.h"
#import "PictographTopBar.h"
#import "PictographButton.h"
#import "PictographDataController.h"
#import "PictographTextField.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "EAIntroView.h"

@interface PictographMainViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, EAIntroDelegate>

typedef NS_ENUM(NSInteger, ImageOption) {
    ImageOptionEncoder,
    ImageOptionDecoder,
    ImageOptionNeither
};

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, assign) ImageOption currentOption;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) MBProgressHUD *progressHUD;

//UI elements
@property (nonatomic, strong) PictographTopBar *topBar;
@property (nonatomic, strong) UIView *encryptionInfoViewBorder;
@property (nonatomic, strong) UILabel *encryptionLabel;
@property (nonatomic, strong) UISwitch *encryptionSwitch;
@property (nonatomic, strong) PictographTextField *encryptionKeyField;
@property (nonatomic, strong) PictographButton *encodeButton;
@property (nonatomic, strong) PictographButton *decodeButton;

@end
