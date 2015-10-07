//
//  AKNavigationController.m
//  Pods
//
//  Created by Ono Masashi on 2015/10/05.
//
//

#import "AKNavigationController.h"
#import "AKNavigationBar.h"

#define kNavigationBarDefaultHeight (44.0)

@interface AKNavigationController ()

@property (null_unspecified, nonatomic) AKNavigationBar *navigationBar;

@property (null_unspecified, nonatomic) NSLayoutConstraint *navigationBarTopConstraint;
@property (null_unspecified, nonatomic) NSLayoutConstraint *navigationBarHeightConstraint;

@end

@implementation AKNavigationController

#pragma mark - Init

- (nonnull instancetype)initWithNavigationBarClass:(nullable Class)navigationBarClass toolbarClass:(nullable Class)toolbarClass
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // TODO: customizable navigationBar/toolbar
        self.viewControllers = @[];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
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
    
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return nil;
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    return nil;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    return nil;
}

- (nullable UIViewController *)topViewController
{
    return nil;
}

- (nullable UIViewController *)visibleViewController
{
    return nil;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    [self setViewControllers:viewControllers animated:NO];
}

- (void)setViewControllers:(nonnull NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated
{
    _viewControllers = [viewControllers copy];
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
