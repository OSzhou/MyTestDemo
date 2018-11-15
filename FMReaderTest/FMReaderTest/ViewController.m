//
//  ViewController.m
//  FMReaderTest
//
//  Created by Windy on 2016/12/19.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "ViewController.h"
//#import "ReaderViewController.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height
@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *sv;

@end

#define DEMO_VIEW_CONTROLLER_PUSH FALSE

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupScrollView];
    
}

- (void)setupScrollView {
    _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    _sv.backgroundColor = [UIColor cyanColor];
    _sv.delegate = self;
    _sv.pagingEnabled = YES;
    _sv.contentSize = CGSizeMake(Screen_W, Screen_H * 3);
    _sv.minimumZoomScale = 1.0;
    _sv.maximumZoomScale = 2.0;
    for (int i = 0; i < 3; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, Screen_H * i, Screen_W, Screen_H)];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i + 1]];
        iv.tag = 100 + i;
        [_sv addSubview:iv];
    }
    [self.view addSubview:_sv];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *iv = (UIImageView *)[self.view viewWithTag:100];
    return iv;
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    
//}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContent]; // Center content
}
- (void)centerScrollViewContent
{
    CGFloat iw = 0.0f; CGFloat ih = 0.0f; // Content width and height insets
    
    CGSize boundsSize = self.view.bounds.size; CGSize contentSize = self.sv.contentSize; // Sizes
    
    if (contentSize.width < boundsSize.width) iw = ((boundsSize.width - contentSize.width) * 0.5f);
    
    if (contentSize.height < boundsSize.height) ih = ((boundsSize.height - contentSize.height) * 0.5f);
    
    UIEdgeInsets insets = UIEdgeInsetsMake(ih, iw, ih, iw); // Create (possibly updated) content insets
    
    if (UIEdgeInsetsEqualToEdgeInsets(self.sv.contentInset, insets) == false) self.sv.contentInset = insets;
}
/*
- (void)readerTest {
    self.view.backgroundColor = [UIColor clearColor]; // Transparent
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *name = [infoDictionary objectForKey:@"CFBundleName"];
    
    NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    self.title = [[NSString alloc] initWithFormat:@"%@ v%@", name, version];
    
    CGSize viewSize = self.view.bounds.size;
    
    CGRect labelRect = CGRectMake(0.0f, 0.0f, 80.0f, 32.0f);
    
    UILabel *tapLabel = [[UILabel alloc] initWithFrame:labelRect];
    
    tapLabel.text = @"Tap";
    tapLabel.textColor = [UIColor whiteColor];
    tapLabel.textAlignment = NSTextAlignmentCenter;
    tapLabel.backgroundColor = [UIColor clearColor];
    tapLabel.font = [UIFont systemFontOfSize:24.0f];
    tapLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    tapLabel.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    tapLabel.center = CGPointMake(viewSize.width * 0.5f, viewSize.height * 0.5f);
    
    [self.view addSubview:tapLabel];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //singleTap.numberOfTouchesRequired = 1; singleTap.numberOfTapsRequired = 1; //singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload {
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) // See README
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    else
        return YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    
    NSString *filePath = [pdfs firstObject]; assert(filePath != nil); // Path to first PDF file
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
        [self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
    }
    else // Log an error so that we know that something went wrong
    {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
}

#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    [self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/

@end
