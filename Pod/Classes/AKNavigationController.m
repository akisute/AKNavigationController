//
//  AKNavigationController.m
//  Pods
//
//  Created by Ono Masashi on 2015/10/05.
//
//

#import "AKNavigationController.h"
#import "AKNavigationBar.h"
#import "AKNavigationControllerAnimator.h"

#define kNavigationBarDefaultHeight (44.0)

@interface AKNavigationController ()

@property (nonatomic, null_unspecified) AKNavigationBar *navigationBar;
@property (nonatomic, null_unspecified) NSLayoutConstraint *navigationBarTopConstraint;
@property (nonatomic, null_unspecified) NSLayoutConstraint *navigationBarHeightConstraint;

@property (nonatomic, null_unspecified) UIView *contentView;

@property (nonatomic, nonnull) AKNavigationControllerAnimator *animator;

@property (nonatomic, nonnull) NSMutableArray<__kindof UIViewController *> *viewControllerStack;

@end

@implementation AKNavigationController

#pragma mark - Init

- (nonnull instancetype)initWithNavigationBarClass:(nullable Class)navigationBarClass toolbarClass:(nullable Class)toolbarClass
{
    // This initializer will be called when this navigation controller is created by code
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // TODO: customizable navigationBar/toolbar
        [self commonInitialize];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    // This initializer will be called when this navigation controller is created from xib/storyboard
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialize];
    }
    return self;
}

- (void)commonInitialize
{
    self.viewControllerStack = [NSMutableArray array];
}

#pragma mark - UIViewController

- (void)loadView
{
    [super loadView];
    {
        self.view.backgroundColor = [UIColor clearColor];
    }
    {
        self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.contentView];
        
        NSDictionary *views = @{@"contentView": self.contentView};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
    }
    {
        self.navigationBar = [[AKNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kNavigationBarDefaultHeight)];
        self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.navigationBar];
        
        NSDictionary *views = @{@"navigationBar": self.navigationBar};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationBar]|" options:0 metrics:nil views:views]];
        
        self.navigationBarTopConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.navigationBar
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:0];
        [self.view addConstraint:self.navigationBarTopConstraint];
        
        self.navigationBarHeightConstraint = [NSLayoutConstraint constraintWithItem:self.navigationBar
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0
                                                                           constant:kNavigationBarDefaultHeight];
        [self.navigationBar addConstraint:self.navigationBarHeightConstraint];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If view controller stack is already pushed before the view is loaded, add it to the view hierarchy
    if (self.topViewController) {
        UIViewController *viewController = self.topViewController;
        [self addChildViewController:viewController];
        [self.contentView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        NSDictionary *views = @{@"view": viewController.view};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGFloat statusBarHeight = MIN(CGRectGetMaxX(statusBarFrame), CGRectGetMaxY(statusBarFrame));
    [self updateNavigationBarPositionY:0 height:kNavigationBarDefaultHeight+statusBarHeight];
}

#pragma mark - Public (UINavigationController)

- (void)pushViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    // Do nothing if the given view controller is already managed by this navigation controller
    if ([self.viewControllerStack containsObject:viewController]) {
        return;
    }
    // If view is not ready, just add it to view controller stack. We'll add it to the view hierarchy later on
    if (!self.isViewLoaded) {
        [self.viewControllerStack addObject:viewController];
        return;
    }
    
    [self.viewControllerStack addObject:viewController];
    
    // TODO: make it animatable
    [self addChildViewController:viewController];
    [self.contentView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    NSDictionary *views = @{@"view": viewController.view};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    // Do nothing if there is no view controller to pop, or already at the root view controller
    if (self.viewControllerStack.count < 2) {
        return nil;
    }
    
    // TODO: make it animatable
    UIViewController *viewControllerToPop = self.viewControllerStack.lastObject;
    [self.viewControllerStack removeLastObject];
    
    [viewControllerToPop willMoveToParentViewController:nil];
    [viewControllerToPop.view removeFromSuperview];
    [viewControllerToPop removeFromParentViewController];
    
    return viewControllerToPop;
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    // Do nothing if there is no view controller to pop, or already at the root view controller
    if (self.viewControllerStack.count < 2) {
        return nil;
    }
    // Do nothing if the given view controller is not found
    if (![self.viewControllerStack containsObject:viewController]) {
        return nil;
    }
    
    // TODO:
    
    return nil;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    if (self.rootViewController == nil) {
        return nil;
    }
    return [self popToViewController:self.rootViewController animated:animated];
}

- (nullable UIViewController *)rootViewController
{
    return self.viewControllerStack.firstObject;
}

- (nullable UIViewController *)topViewController
{
    return self.viewControllerStack.lastObject;
}

- (nullable UIViewController *)visibleViewController
{
    if (self.presentedViewController) {
        return self.presentedViewController;
    }
    return self.topViewController;
}

- (NSArray<__kindof UIViewController *> *)viewControllers
{
    return [self.viewControllerStack copy];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    [self setViewControllers:viewControllers animated:NO];
}

- (void)setViewControllers:(nonnull NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated
{
    // TODO:
    self.viewControllerStack = [viewControllers mutableCopy];
}

- (BOOL)isNavigationBarHidden
{
    return self.navigationBar.hidden;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    [self setNavigationBarHidden:navigationBarHidden animated:NO];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    self.navigationBar.hidden = hidden;
}

- (void)showViewController:(nonnull UIViewController *)vc sender:(nullable id)sender
{
    [self pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)updateNavigationBarPositionY:(CGFloat)positionY height:(CGFloat)height
{
    self.navigationBarTopConstraint.constant = -positionY; // must be inverted before applying to constant
    self.navigationBarHeightConstraint.constant = height;
    [self.view setNeedsLayout];
}

@end
