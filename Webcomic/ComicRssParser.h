//
//  ComicRssParser.h
//  Webcomic
//
//  Created by Liu Di on 9/25/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>
//A parser class for parsing rss feed
@class ComicRss;

@protocol ComicRssParserDelegate;

@interface ComicRssParser : NSObject{
    ComicRss * _currentItem;
	NSMutableString * _currentItemValue;
	NSMutableArray * _rssItems;
	id<ComicRssParserDelegate> _delegate;
	NSOperationQueue *_retrieverQueue;
}

@property(nonatomic, retain) ComicRss * currentItem;
@property(nonatomic, retain) NSMutableString * currentItemValue;
@property(readonly) NSMutableArray * rssItems;

@property id<ComicRssParserDelegate> delegate;
@property(nonatomic, retain) NSOperationQueue *retrieverQueue;

- (void)startProcess;


@end

@protocol ComicRssParserDelegate <NSObject>

-(void)processCompleted;
-(void)processHasErrors;

@end