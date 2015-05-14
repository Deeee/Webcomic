//
//  DetailViewController.m
//  Webcomic
//
//  Created by Liu Di on 9/25/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ComicRss.h"
#define MAXIMUM_SCALE 6.0
#define MINIMUM_SCALE 1.0
@implementation DetailViewController

@synthesize appDelegate = _appDelegate;
@synthesize titleTextView = _titleTextView;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize toolbar = _toolbar;
@synthesize image = _image;
@synthesize scrollView = _scrollView;

-(void)viewDidLoad{
	[super viewDidLoad];
	
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]
                                     initWithImage:[UIImage imageNamed:@"forward_32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openWebLink)];
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.contentSize = self.image.frame.size;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];

	NSArray *items = [NSArray arrayWithObjects: actionButton, nil];
	[self.toolbar setItems:items animated:NO];
}
//Open web link in the browser
-(void)openWebLink{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to open current item in browser?"
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromToolbar:_toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 0){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[self appDelegate] currentlySelectedComicItem]linkUrl]]];
	}
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	NSString * mediaUrl = [[[self appDelegate]currentlySelectedComicItem]mediaUrl];
	[[self image]setImage:[UIImage imageNamed:@"unknown.jpg"]];
	if(nil != mediaUrl){
		NSData* imageData;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		@try {
			imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:mediaUrl]];
		}
		@catch (NSException * e) {
            NSLog(@"downloading error!");
			//Some error while downloading data
		}
		@finally {
			UIImage * imageFromImageData = [[UIImage alloc] initWithData:imageData];
			[[self image]setImage:imageFromImageData];
            _image.contentMode = UIViewContentModeScaleAspectFit;
		}
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	self.titleTextView.text = [[[self appDelegate] currentlySelectedComicItem]title];
	self.descriptionTextView.text = [[[self appDelegate] currentlySelectedComicItem]description];
    self.title = [[[self appDelegate] currentlySelectedComicItem] title];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.image;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
}

@end
