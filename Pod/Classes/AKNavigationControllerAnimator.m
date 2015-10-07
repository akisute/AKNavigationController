//
//  LNNavigationControllerAnimator.m
//  Pods
//
//  Created by Ono Masashi on 2015/10/05.
//

#import "AKNavigationControllerAnimator.h"

@interface AKNavigationControllerAnimator ()
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> lastTransitionContext;
@end

@implementation AKNavigationControllerAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.lastTransitionContext = transitionContext;
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.lastTransitionContext = transitionContext;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [self animateTransitionForiOS7:transitionContext];
    } else {
        [self animateTransitionForiOS8OrLater:transitionContext];
    }
}

#pragma mark - Public

- (UIViewController *)lastFromViewController
{
    return [self.lastTransitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
}

- (UIViewController *)lastToViewController
{
    return [self.lastTransitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
}

#pragma mark - Private

- (void)animateTransitionForiOS8OrLater:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (toView) {
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toView.frame = [transitionContext finalFrameForViewController:toViewController];
    }
    
    CGRect fromStartFrame;
    CGRect fromEndFrame;
    CGRect toStartFrame;
    CGRect toEndFrame;
    
    if (self.dismissing) {
        // dismiss
        // - toView could be nil (e.g. when view is presented by presentViewController:)
        if (toView) {
            [[transitionContext containerView] addSubview:toView];
            [[transitionContext containerView] sendSubviewToBack:toView];
        }
        
        fromStartFrame = fromView.frame;
        fromEndFrame = fromView.frame;
        fromEndFrame.origin.x = fromStartFrame.origin.x + fromStartFrame.size.width;
        if (toView) {
            toStartFrame = toView.frame;
            toEndFrame = toView.frame;
            toStartFrame.origin.x = toStartFrame.origin.x - 100.0;
        }
        
        fromView.alpha = 1;
        fromView.frame = fromStartFrame;
        if (toView) {
            toView.alpha = 0;
            toView.frame = toStartFrame;
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromView.alpha = 1;
            fromView.frame = fromEndFrame;
            if (toView) {
                toView.alpha = 1;
                toView.frame = toEndFrame;
            }
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        // present
        // - fromView could be nil (e.g. when view is presented by presentViewController:)
        [[transitionContext containerView] addSubview:toView];
        [[transitionContext containerView] bringSubviewToFront:toView];
        
        if (fromView) {
            fromStartFrame = fromView.frame;
            fromEndFrame = fromView.frame;
            fromEndFrame.origin.x = fromEndFrame.origin.x - 100.0;
        }
        toStartFrame = toView.frame;
        toEndFrame = toView.frame;
        toStartFrame.origin.x = toEndFrame.origin.x + toEndFrame.size.width;
        
        if (fromView) {
            fromView.alpha = 1;
            fromView.frame = fromStartFrame;
        }
        toView.alpha = 1;
        toView.frame = toStartFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (fromView) {
                fromView.alpha = 1;
                fromView.frame = fromEndFrame;
            }
            toView.alpha = 1;
            toView.frame = toEndFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (void)animateTransitionForiOS7:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // XXX: 現在pop側のanimationにしか対応していません。push側のanimationに対応させるためには追加の修正が必要です。
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (self.dismissing) {
        // Pop
        [[transitionContext containerView] addSubview:toViewController.view];
        [[transitionContext containerView] sendSubviewToBack:toViewController.view];
        
        CGRect fromStartFrame = fromViewController.view.frame;
        CGRect fromEndFrame = fromStartFrame;
        fromEndFrame.origin.x = fromEndFrame.size.width;
        CGRect toStartFrame = toViewController.view.frame;
        CGRect toEndFrame = toStartFrame;
        toStartFrame.origin.x = toStartFrame.origin.x - 100.0;
        toViewController.view.alpha = 0;
        fromViewController.view.alpha = 1;
        toViewController.view.frame = toStartFrame;
        fromViewController.view.frame = fromStartFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            toViewController.view.frame = toEndFrame;
            fromViewController.view.frame = fromEndFrame;
            toViewController.view.alpha = 1;
            fromViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                fromViewController.view.frame = fromStartFrame;
                toViewController.view.frame = fromEndFrame;
                toViewController.view.alpha = 1;
                fromViewController.view.alpha = 1;
            } else {
                fromViewController.view.frame = fromEndFrame;
                toViewController.view.alpha = 1;
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        // Push
        [[transitionContext containerView] addSubview:toViewController.view];
        [[transitionContext containerView] bringSubviewToFront:toViewController.view];
        
        CGRect fromStartFrame = fromViewController.view.frame;
        CGRect fromEndFrame = fromStartFrame;
        fromEndFrame.origin.x = fromEndFrame.origin.x - 100.0;
        CGRect toStartFrame = toViewController.view.frame;
        CGRect toEndFrame = toStartFrame;
        toStartFrame.origin.x = fromStartFrame.size.width;
        toEndFrame.origin.x = fromStartFrame.origin.x;
        toViewController.view.frame = toStartFrame;
        fromViewController.view.frame = fromStartFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toViewController.view.frame = toEndFrame;
            fromViewController.view.frame = fromEndFrame;
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                fromViewController.view.frame = fromStartFrame;
                toViewController.view.frame = fromEndFrame;
            } else {
                fromViewController.view.frame = fromEndFrame;
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
