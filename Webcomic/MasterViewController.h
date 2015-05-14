//
//  MasterViewController.h
//  Webcomic
//
//  Created by Liu Di on 9/25/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicRssParser.h"

@class ComicRss;
@class ComicRssParser;
@class AppDelegate;
@class DetailViewController;
//View controller for master view
@interface MasterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ComicRssParserDelegate> {
    ComicRssParser * _rssParser;
	UITableView * _tableView;
	AppDelegate * _appDelegate;
	UIToolbar * _toolbar;
}

@property (nonatomic,retain) IBOutlet ComicRssParser * rssParser;
@property (nonatomic,retain) IBOutlet UITableView * tableView;
@property (nonatomic,retain) IBOutlet UIToolbar * toolbar;
@property (nonatomic,retain) IBOutlet AppDelegate * appDelegate;

-(void)toggleToolBarButtons:(BOOL)newState;

@end
