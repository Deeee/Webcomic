//
//  MasterViewController.m
//  Webcomic
//
//  Created by Liu Di on 9/25/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "MasterViewController.h"
#import "ComicRssParser.h"
#import "ComicRss.h"
#import "AppDelegate.h"

@implementation MasterViewController

@synthesize rssParser = _rssParser;
@synthesize tableView = _tableView;
@synthesize appDelegate = _appDelegate;
@synthesize toolbar = _toolbar;

-(void)toolbarInit{
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                      target:self action:@selector(reloadRss)];
	refreshButton.enabled = NO;
	NSArray *items = [NSArray arrayWithObjects: refreshButton,  nil];
	[self.toolbar setItems:items animated:NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	[self toolbarInit];
	_rssParser = [[ComicRssParser alloc]init];
	self.rssParser.delegate = self;
	[[self rssParser]startProcess];
    self.title = @"WebComic";
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
}
// Method for reloading rss feed
-(void)reloadRss{
	[self toggleToolBarButtons:NO];
	[[self rssParser]startProcess];
}

-(void)toggleToolBarButtons:(BOOL)newState{
	NSArray *toolbarItems = self.toolbar.items;
	for (UIBarButtonItem *item in toolbarItems){
		item.enabled = newState;
	}
}

// Delegate method for comic parser will get fired when the process is completed
- (void)processCompleted{
	//reload the table view
	[self toggleToolBarButtons:YES];
	[[self tableView]reloadData];
}

-(void)processHasErrors{
	//Might be due to Internet
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comic viewer" message:@"Unable to download rss. Please check if you are connected to internet."
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[self toggleToolBarButtons:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [[[self rssParser]rssItems]count];
}
// Initialize table cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rssItemCell"];
	if(nil == cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"rssItemCell"];
	}
	cell.textLabel.text = [[[[self rssParser]rssItems]objectAtIndex:indexPath.row]title];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[self appDelegate] setCurrentlySelectedComicItem:[[[self rssParser]rssItems]objectAtIndex:indexPath.row]];
	[self.appDelegate loadComicDetails];
}



@end
