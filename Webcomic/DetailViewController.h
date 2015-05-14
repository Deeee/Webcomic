//
//  DetailViewController.h
//  Webcomic
//
//  Created by Liu Di on 9/25/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
//Detail view controller
@interface DetailViewController : UIViewController <UIActionSheetDelegate, UIScrollViewDelegate>{
    AppDelegate * _appDelegate;
	UITextView * _titleTextView;
	UITextView * _descriptionTextView;
	UIToolbar * _toolbar;
	UIImageView * _image;
    UIScrollView *_scrollView;
}

@property (nonatomic, retain) IBOutlet AppDelegate * appDelegate;
@property (nonatomic, retain) IBOutlet UITextView * titleTextView;
@property (nonatomic, retain) IBOutlet UITextView * descriptionTextView;
@property (nonatomic, retain) IBOutlet UIToolbar * toolbar;
@property (nonatomic, retain) IBOutlet UIImageView * image;
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;

@end
