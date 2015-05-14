//
//  ComicRss.h
//  Webcomic
//
//  Created by Liu Di on 9/25/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>
//Comic rss object, each contains the basic info about a comic
@interface ComicRss : NSObject {
	NSString * _title;
	NSString * _description;
	NSString * _linkUrl;
	NSString * _guidUrl;
	NSDate * _pubDate;
	NSString * _mediaUrl;
}

@property(nonatomic, copy) NSString * title;
@property(nonatomic, copy) NSString * description;
@property(nonatomic, copy) NSString * linkUrl;
@property(nonatomic, copy) NSString * guidUrl;
@property(nonatomic, retain) NSDate * pubDate;
@property(nonatomic,copy) NSString * mediaUrl;


@end
