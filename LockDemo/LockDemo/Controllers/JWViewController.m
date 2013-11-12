//
//  JWViewController.m
//  LockDemo
//
//  Created by Jake Widmer on 11/12/13.
//  Copyright (c) 2013 yourcompany. All rights reserved.
//

#import "JWViewController.h"

@interface JWViewController ()

@end

@implementation JWViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)resetPasscodeButtonPressed:(id)sender {
    // Reset user defaults and save the change
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"hasSetPasscode"];
    [defaults synchronize];

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)lockButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
