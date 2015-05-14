//
//  ComicRss.m
//  Webcomic
//
//  Created by Liu Di on 9/25/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "ComicRss.h"

@implementation ComicRss
@synthesize title = _title;
@synthesize description = _description;
@synthesize linkUrl = _linkUrl;
@synthesize guidUrl = _guidUrl;
@synthesize pubDate = _pubDate;
@synthesize mediaUrl = _mediaUrl;

-(void)dealloc{
	self.title = nil;
	self.description = nil;
	self.linkUrl = nil;
	self.guidUrl = nil;
	self.pubDate = nil;
	self.mediaUrl = nil;
}
@end
