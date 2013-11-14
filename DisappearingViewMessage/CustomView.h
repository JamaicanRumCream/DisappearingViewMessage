//
//  CustomView.h
//  DisappearingViewMessage
//
//  Created by Chris Paveglio on 11/13/13.
//  Copyright (c) 2013 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView

@property (weak, nonatomic) IBOutlet UITextView *textView;

-(float)expandedCellHeight;

@end
