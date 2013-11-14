//
//  CustomView.m
//  DisappearingViewMessage
//
//  Created by Chris Paveglio on 11/13/13.
//  Copyright (c) 2013 none. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

@synthesize textView;


-(float)expandedCellHeight
{    
    //find the base cell height, subtract the current subtext height
    //to get the remainder
    float currentFrameHt = self.frame.size.height;
    float currentSTVHeight = self.textView.frame.size.height;
    float frameRemainder = currentFrameHt - currentSTVHeight;
    
    //this will be the height of only the full subtextView
    CGRect newTextViewFrame = self.textView.frame;
    newTextViewFrame.size.height = self.textView.contentSize.height;
    float stVHeight = self.textView.contentSize.height;
    
    //add subtextView box and remainder for entire cell height
    float combinedHeight = frameRemainder + stVHeight;
    
    return combinedHeight;
}

@end
