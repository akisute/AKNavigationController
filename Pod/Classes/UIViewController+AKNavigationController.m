//
//  UIViewController+AKNavigationController.m
//  Pods
//
//  Created by Ono Masashi on 2015/10/09.
//
//

#import "UIViewController+AKNavigationController.h"
#import "AKNavigationController.h"

@implementation UIViewController (AKNavigationController)

- (nullable AKNavigationController *)AKNavigationController
{
    if ([self.parentViewController isKindOfClass:[AKNavigationController class]]) {
        return (AKNavigationController *)self.parentViewController;
    }
    return nil;
}

@end
