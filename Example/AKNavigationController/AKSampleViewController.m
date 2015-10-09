//
//  AKSampleViewController.m
//  AKNavigationController
//
//  Created by Ono Masashi on 2015/10/08.
//  Copyright © 2015年 Ono Masashi. All rights reserved.
//

#import <AKNavigationController/AKNavigationController.h>
#import "AKSampleViewController.h"

@interface AKSampleViewController ()
@property (nonatomic, weak) IBOutlet UIButton *pushSampleViewController1Button;
@end

@implementation AKSampleViewController

+ (nonnull instancetype)instantiateFromStoryboard
{
    return [[UIStoryboard storyboardWithName:@"AKSampleViewController" bundle:nil] instantiateInitialViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (IBAction)onPushSampleViewController1Button:(id)sender
{
    AKSampleViewController *sampleViewController1 = [AKSampleViewController instantiateFromStoryboard];
    AKNavigationController *navigationController = self.AKNavigationController;
    [navigationController pushViewController:sampleViewController1 animated:YES];
}

@end
