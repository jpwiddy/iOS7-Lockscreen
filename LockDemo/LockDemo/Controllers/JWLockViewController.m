//
//  JWLockViewController.m
//  LockDemo
//
//  Created by Jake Widmer on 11/12/13.
//  Copyright (c) 2013 yourcompany. All rights reserved.
//

#import "JWLockViewController.h"

@interface JWLockViewController ()
@property (strong, nonatomic) IBOutlet UILabel *PasscodeLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *NumberButtons;

@end

@implementation JWLockViewController{
    NSString * passcodeKey;
    NSMutableString * passcodeEntered;
    NSMutableString * enteredDots;
    NSString * temp;
    BOOL passcodeSet;
    int attempts, fails;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self.PasscodeLabel setText:@"Enter Passcode"];
        
        //passcodeKey = @"1234";      // default, example passcode
        passcodeEntered = [[NSMutableString alloc] init];
        enteredDots = [[NSMutableString alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        passcodeKey = [defaults objectForKey:@"PASSCODE"];
        [defaults synchronize];
        
        passcodeSet = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // COMMENT FOR BUTTONS TO NOT BE CIRCLED
     for(UIButton * button in self.NumberButtons){
         CALayer *btnLayer = [button layer];
         [btnLayer setMasksToBounds:YES];
         [btnLayer setCornerRadius: 22.0f];
         // Apply a 1 pixel, black border
         [btnLayer setBorderWidth:1.0f];
         [btnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
     }
     //
}
- (void) viewWillAppear:(BOOL)animated{
    attempts = fails = 0;
    [self reset];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSetPasscode"]){
        // prompt for setting of passcode
        [self.PasscodeLabel setText:@"Enter New Passcode"];
        passcodeSet = NO;
    }
    else
        [self.PasscodeLabel setText:@"Enter Passcode"];
}


- (IBAction)LockButtonPressed:(id)sender {
    NSInteger tag = [(UIButton *)sender tag];
    
	if ( tag < 10 ) {
		[passcodeEntered appendString:[NSString stringWithFormat:@"%d", tag]];
		[enteredDots appendString:@"*"];
		[self updateLabel];
	}
    if(tag == 10){  // clear
        [self reset];
        [self.PasscodeLabel setText:@"Enter Passcode"];
    }
    if(tag == 11){  // back
        if ([passcodeEntered length] > 0){
            temp = [passcodeEntered substringToIndex:[passcodeEntered length] - 1];
            [passcodeEntered setString: temp];
            temp = [enteredDots substringToIndex:[enteredDots length] - 1];
            [enteredDots setString: temp];
            
            [self updateLabel];
        }
        if ([passcodeEntered length] == 0)
            [self.PasscodeLabel setText:@"Enter Passcode"];
    }
    if(passcodeEntered.length == 4){
        attempts += 1;
        if(!passcodeSet){
            passcodeKey = [[NSString alloc] initWithString:passcodeEntered];
            passcodeSet = YES;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:passcodeEntered forKey:@"PASSCODE"];
            [defaults synchronize];
            NSLog(@"SET PC %d", passcodeSet);
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSetPasscode"];
            [self unlock];
            return;
        }
        else if([self checkPasscode]){
            [self unlock];
            return;
        }
        else if(attempts == 5){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"Are you sure this is your iPhone? Attempting to access sensitive information that you are not authorized to is illegal."
                                  delegate:nil
                                  cancelButtonTitle:@"Dismiss"
                                  otherButtonTitles:nil];
            [alert show];
            attempts = 0;
            fails += 1;
            [self incorrectPasscode];
            return;
        }
        else{
            [self incorrectPasscode];
            return;
        }
    }
}

#pragma mark - Helper functions

- (BOOL) checkPasscode{ // checks complete and then if it matches
    if([passcodeEntered isEqualToString:passcodeKey])
        return YES;
    return NO;
}
- (void) updateLabel{
    [self.PasscodeLabel setText:enteredDots];
}
- (void) unlock{
    [self performSegueWithIdentifier:@"UnlockSegue" sender:self];
}
- (void) reset{
    [passcodeEntered setString: @""];
    [enteredDots setString: @""];
}
- (void) incorrectPasscode{
    [self.PasscodeLabel setText:@"Incorrect - Try Again"];
    [self reset];
}
@end

