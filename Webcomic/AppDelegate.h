//
//  AppDelegate.h
//  Webcomic
//
//  Created by Liu Di on 9/25/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterViewController;
@class DetailViewController;
@class ComicRss;
//App delegate
@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
    MasterViewController *_viewController;
    UINavigationController *navigationController;
    DetailViewController *_detailViewController;
    ComicRss *_currentlySelectedComicItem;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;
@property (nonatomic, retain) IBOutlet MasterViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController * navigationController;
@property (nonatomic,retain) IBOutlet DetailViewController * detailController;

@property (readwrite,retain)  ComicRss* currentlySelectedComicItem;
-(void)loadComicDetails;
@end
