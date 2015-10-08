//
//  AKNavigationController.h
//  Pods
//
//  Created by Ono Masashi on 2015/10/05.
//
//

#import <UIKit/UIKit.h>

@class AKNavigationBar;

@interface AKNavigationController : UIViewController

- (nonnull instancetype)initWithNavigationBarClass:(nullable Class)navigationBarClass toolbarClass:(nullable Class)toolbarClass;

#pragma mark - UINavigationController

- (void)pushViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated;
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated;
- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated;

@property(nullable, nonatomic,readonly,strong) UIViewController *rootViewController;
@property(nullable, nonatomic,readonly,strong) UIViewController *topViewController;
@property(nullable, nonatomic,readonly,strong) UIViewController *visibleViewController;

@property(nonnull, nonatomic,copy) NSArray<__kindof UIViewController *> *viewControllers;
- (void)setViewControllers:(nonnull NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated;

@property(nonatomic,getter=isNavigationBarHidden) BOOL navigationBarHidden;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
@property(nonnull, nonatomic,readonly) AKNavigationBar *navigationBar;

- (void)showViewController:(nonnull UIViewController *)vc sender:(nullable id)sender;

@end
