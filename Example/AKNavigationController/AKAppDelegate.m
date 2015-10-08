//
//  AKAppDelegate.m
//  AKNavigationController
//
//  Created by Ono Masashi on 10/05/2015.
//  Copyright (c) 2015 Ono Masashi. All rights reserved.
//

#import "AKAppDelegate.h"
#import "AKNavigationController.h"
#import "AKSampleViewController.h"

@interface AKAppDelegate ()

@property (nonatomic, null_unspecified) AKNavigationController *navigationController;

@end

@implementation AKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.navigationController = (AKNavigationController *)self.window.rootViewController;
    
    AKSampleViewController *sampleViewController1 = [[AKSampleViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:sampleViewController1 animated:NO];
    
    return YES;
}

@end
