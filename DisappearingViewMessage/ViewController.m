//
//  ViewController.m
//  DisappearingViewMessage
//
//  Created by Chris Paveglio on 11/12/13.
//  Copyright (c) 2013 none. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController

- (void)viewDidLoad
{    [super viewDidLoad];   }

- (void)didReceiveMemoryWarning
{    [super didReceiveMemoryWarning];   }


#pragma mark - Programatic Dialog

- (IBAction)showViewDialog:(id)sender
{
    //setup a basic rectangle for a view
    CGRect viewRect = CGRectMake(10.0, 10.0, 300.0, 100.0);
    UIView *simpleView = [[UIView alloc] initWithFrame:viewRect];
    [simpleView setBackgroundColor:[UIColor redColor]];
    
    //add a text label to it, remember to inset the rect, it's relative to the superview
    UILabel *basicLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 280.0, 80.0)];
    [basicLabel setText:@"Basic View with Label"];
    [basicLabel setBackgroundColor:[UIColor clearColor]];
    [simpleView addSubview:basicLabel];
    
    //add view to main display view
    [[self view] addSubview:simpleView];
    
    NSLog(@"view shown");
    
    /* USE ONE OF THESE FOR VIEW REMOVAL */
    
//  [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(dismissViewAnimated:) userInfo:simpleView repeats:NO];
//OR
//  [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(dismissView:) userInfo:simpleView repeats:NO];
    //NSTimer passes itself as parameter to the selector
    //so, store a ref to the alert view into the userInfo
    
//OR    
    //this method doesn't require explicit timer
    [self performSelector:@selector(dismissViewAnimatedDelay:) withObject:simpleView];
}

-(void)dismissView:(id)sender
{
    NSLog(@"view dismissed");
    [(UIView *)[sender userInfo] removeFromSuperview];
    //get the userInfo object (the alertview) to tell it to close
    //make sure to cast it as  (UIView *) or compiler has no idea what userInfo is
}

-(void)dismissViewAnimated:(id)sender
{
    NSLog(@"view dismiss animated");
    UIView *floatingView = (UIView *)[sender userInfo];
    //pull the ref for the floating view we want to dismiss
    
    [UIView animateWithDuration:1.0 //other method includes: delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        floatingView.alpha = 0.0;  }
                     completion:^(BOOL finished){
        [floatingView removeFromSuperview]; }];
}

-(void)dismissViewAnimatedDelay:(id)sender
{
    NSLog(@"view dismiss animated delay");
    //sender is the passed view
    
    [UIView animateWithDuration:1.0 delay:3.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         ((UIView *)sender).alpha = 0.0;  }
                     completion:^(BOOL finished){
                         [(UIView *)sender removeFromSuperview]; }];
}


#pragma mark - XIB Dialog

- (IBAction)showXIBDialog:(id)sender
{
    NSLog(@"showXIBDialog");
    
    //longer and shorter sample strings
    //NSString *sampleString = @"789 Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    NSString *sampleString = @"123 Lorem ipsum dolor sit er elit lamet, consecte taur anim id est laborum. Nam liber te conscient to factor tum poen.";
    //NSString *sampleString = @"";
    
    [self performSelector:@selector(showAndDismissFadeWithMessage:) withObject:sampleString];
}

-(void)showAndDismissFadeWithMessage:(NSString *)aString
{
    float windowInset = 10.0;
    float appViewHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    float appViewWidth  = [[UIScreen mainScreen] applicationFrame].size.width;
    
    //load a view object and get it's item 0 (first view)
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
    CustomView *customView = [nibArray objectAtIndex:0];
    
    //apply string to the view
    [[customView textView] setText:aString];
    float viewHeight = [customView expandedCellHeight];
    //get cell size now that text is applied
    
    //limit view height to fit inside the window
    float maxViewHeight = appViewHeight - (windowInset * 2.0);
    if (viewHeight > maxViewHeight) {
        viewHeight = maxViewHeight;
    }
    
    //center view on screen, if not set top point to windowInset
    float topPoint = (appViewHeight / 2.0) - (viewHeight / 2.0);
    
    //set the view height now
    [customView setFrame:CGRectMake(windowInset, topPoint, appViewWidth - (windowInset * 2.0), viewHeight)];
    
    //put a drop shadow on the view
    //FIRST add QUARTZCore framework to project and import into this .m file
    customView.layer.shadowColor = [[UIColor blackColor] CGColor];
    customView.layer.shadowOpacity = 0.7;
    customView.layer.shadowRadius = 5.0;
    customView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    customView.layer.shadowPath = [UIBezierPath bezierPathWithRect:customView.bounds].CGPath;
    
    //show the view on screen
    [[self view] addSubview:customView];
    
    //fire the delay animation right away
    [UIView animateWithDuration:1.0 delay:2.2 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         customView.alpha = 0.0;  }
                     completion:^(BOOL finished){
                         [customView removeFromSuperview]; }];
    
    //NOTE: dismissing a view in this manner precludes user interaction and scrolling
    //you'd have to enable a button to dismiss in order to allow foreground interaction
}


@end
