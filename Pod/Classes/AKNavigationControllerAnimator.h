//
//  AKNavigationControllerAnimator.h
//  Pods
//
//  Created by Ono Masashi on 2015/10/05.
//

#import <UIKit/UIKit.h>

@interface AKNavigationControllerAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL dismissing;

@property (nonatomic, weak, readonly) UIViewController *lastFromViewController;
@property (nonatomic, weak, readonly) UIViewController *lastToViewController;

@end
