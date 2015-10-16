//
//  ViewController.m
//  Pictograph
//
//  Created by Adam on 2015-09-30.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "ViewController.h"

#define kButtonHeight 60

@interface ViewController ()

- (void)showChoosePhotoActionSheet;
- (UIImagePickerController *)buildImagePickerWithSourceType:(UIImagePickerControllerSourceType)type;
- (void)startEncodingOrDecoding;
- (void)buildAndShowMessageAlertWithConfirmHandler:(void (^ __nullable)(UIAlertAction *action))handler;
- (void)showShareSheetWithImage:(UIImage *)image;

@end

@implementation ViewController

@synthesize selectedImage;
@synthesize navBar;
@synthesize mainView;
@synthesize encodeButton;
@synthesize decodeButton;
@synthesize currentOption;
@synthesize alertController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Background color
    [self.view setBackgroundColor:[UIColor redColor]];
    
    //Nav bar
    navBar = [[UIView alloc] init];
    [navBar setBackgroundColor:[UIColor redColor]];
    [navBar setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addSubview:navBar];
    
    //10px from top, 0px from left & right, 44px height
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    
    //Main view, contains buttons and imageview
    mainView = [[UIView alloc] init];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [mainView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addSubview:mainView];
    
    //0px from bottom of navbar, 0px from left, right, bottom
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:navBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    
    //Encode button
    encodeButton = [[UIButton alloc] init];
    [encodeButton addTarget:self action:@selector(encodeMessage) forControlEvents:UIControlEventTouchUpInside];
    [encodeButton setBackgroundColor:[UIColor whiteColor]];
    [encodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [encodeButton setTitle:@"Encode Message" forState:UIControlStateNormal];
    [encodeButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addSubview:encodeButton];
    
    //0px from left, bottom, center, 60px tall
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:encodeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:encodeButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:encodeButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:encodeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonHeight]];
    
    
    //Decode button
    decodeButton = [[UIButton alloc] init];
    [decodeButton addTarget:self action:@selector(decodeMessage) forControlEvents:UIControlEventTouchUpInside];
    [decodeButton setBackgroundColor:[UIColor whiteColor]];
    [decodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [decodeButton setTitle:@"Decode Message" forState:UIControlStateNormal];
    [decodeButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addSubview:decodeButton];
    
    //0px from bottom, right, center, 60px tall
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:decodeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:decodeButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:decodeButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:decodeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonHeight]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom methods

- (void)encodeMessage {
    currentOption = ImageOptionEncoder;
    [self showChoosePhotoActionSheet];
}

- (void)decodeMessage {
    currentOption = ImageOptionDecoder;
    [self showChoosePhotoActionSheet];
}

//Showing the action sheet
- (void)showChoosePhotoActionSheet {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //Device has camera & library, show option to choose
        alertController = [UIAlertController alertControllerWithTitle:@"Select Picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //Cancel action
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { /* No action needed */ }];
        [alertController addAction:cancelAction];
        
        //Library action
        UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Select from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //Choose photo from library, present library view controller
            UIImagePickerController *picker = [self buildImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:picker animated:true completion:NULL];
            
        }];
        [alertController addAction:libraryAction];
        
        //Take photo action
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //Take a photo
            UIImagePickerController *picker = [self buildImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:picker animated:true completion:NULL];
            
        }];
        [alertController addAction:takePhotoAction];
        
        [self presentViewController:alertController animated:true completion:^{}];
        
    } else {
        //Device has no camera, just show library
        UIImagePickerController *picker = [self buildImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:picker animated:true completion:NULL];
        
    }
}

//Builds a UIImagePickerController with source type
- (UIImagePickerController *)buildImagePickerWithSourceType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = type;
    
    return picker;
}

//Encoding or decoding the selected image
- (void)startEncodingOrDecoding {
    
    if (currentOption == ImageOptionEncoder) {
        //Encoding the image with a message, need to get message
        [self buildAndShowMessageAlertWithConfirmHandler:^(UIAlertAction *action) {
            
            //Action that happens when confirm is hit
            UITextField *messageField = alertController.textFields.firstObject;
            
            //Completing the action goes here
            UIImageCoder *coder = [[UIImageCoder alloc] init];
            
            UIImage *encodedImage = [coder encodeImage:selectedImage withMessage:messageField.text];
            
            if (encodedImage) {
                //Show the share sheet if the image exists
                [self showShareSheetWithImage:encodedImage];
            
            } else {
                //TODO: Show an error here, most likely the image was too small or the message was too big
            }
            
        }];
        
    } else if (currentOption == ImageOptionDecoder) {
        //Decoding the image
        
        UIImageCoder *coder = [[UIImageCoder alloc] init];
        
        NSString *decodedMessage = [coder decodeImage:selectedImage];
        
        if (decodedMessage) {
            [self showDecodedMessageInAlertController:decodedMessage];
        }
        
    }
}

//Building the alert that gets the message that the user should type
- (void)buildAndShowMessageAlertWithConfirmHandler:(void (^ __nullable)(UIAlertAction *action))handler {
    alertController = [UIAlertController alertControllerWithTitle:@"Enter your message" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //Action for confirming the message
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:handler];
    [confirmAction setEnabled:false]; //Enabled or disabled based on text input
    [alertController addAction:confirmAction];
    
    
    //Action for cancelling
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
    [alertController addAction:cancelAction];
    
    
    //Adding message field
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.placeholder = @"Your message here";
        
        //Confirm is only enabled if there is text
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [confirmAction setEnabled:![[textField text] isEqualToString:@""]];
        }];
        
     }];
    
    [self presentViewController:alertController animated:true completion:NULL];
}

//Shows the share sheet with the UIImage image
- (void)showShareSheetWithImage:(UIImage *)image {
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:NULL];
}

//Shows the decoded message in an alert controller
- (void)showDecodedMessageInAlertController:(NSString *)message {
    alertController = [UIAlertController alertControllerWithTitle:@"Decoded Message" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:NULL];
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:true completion:NULL];
}

#pragma mark UIImagePickerControllerDelegate

//User picked image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    selectedImage = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self startEncodingOrDecoding];
}

//User cancelled
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    currentOption = ImageOptionNeither;
}

@end
