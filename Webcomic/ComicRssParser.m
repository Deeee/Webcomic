//
//  ComicRssParser.m
//  Webcomic
//
//  Created by Liu Di on 9/25/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "ComicRssParser.h"
#import "ComicRss.h"

@implementation ComicRssParser

@synthesize currentItem = _currentItem;
@synthesize currentItemValue = _currentItemValue;
@synthesize rssItems = _rssItems;
@synthesize delegate = _delegate;
@synthesize retrieverQueue = _retrieverQueue;

- (id)init{
	if(![super init]){
		return nil;
	}
	_rssItems = [[NSMutableArray alloc]init];
	return self;
}

- (NSOperationQueue *)retrieverQueue {
	if(nil == _retrieverQueue) {
		_retrieverQueue = [[NSOperationQueue alloc] init];
		_retrieverQueue.maxConcurrentOperationCount = 1;
	}
	return _retrieverQueue;
}

- (void)startProcess{
	SEL method = @selector(fetchAndParseRss);
	[[self rssItems] removeAllObjects];
	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self
																	 selector:method
																	   object:nil];
	[self.retrieverQueue addOperation:op];
}

-(BOOL)fetchAndParseRss{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	//To suppress the leak in NSXMLParser
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	
	NSURL *url = [NSURL URLWithString:@"http://xkcd.com/rss.xml"];
	BOOL success = NO;
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldReportNamespacePrefixes:YES];
	[parser setShouldResolveExternalEntities:NO];
	success = [parser parse];
	return success;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	if(nil != qualifiedName){
		elementName = qualifiedName;
	}
	if ([elementName isEqualToString:@"item"]) {
		self.currentItem = [[ComicRss alloc]init];
	}else if ([elementName isEqualToString:@"image"]) {
		self.currentItem.mediaUrl = [attributeDict valueForKey:@"url"];
	} else if([elementName isEqualToString:@"title"] ||
			  [elementName isEqualToString:@"description"] ||
			  [elementName isEqualToString:@"link"] ||
			  [elementName isEqualToString:@"guid"] ||
			  [elementName isEqualToString:@"pubDate"]) {
		self.currentItemValue = [NSMutableString string];
	} else {
		self.currentItemValue = nil;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if(nil != qName){
		elementName = qName;
	}
	if([elementName isEqualToString:@"title"]){
		self.currentItem.title = self.currentItemValue;
	}else if([elementName isEqualToString:@"description"]){
        if ([self.currentItemValue rangeOfString:@"img src="].location != NSNotFound) {
            NSString *tmp;
            NSScanner *scanner = [NSScanner scannerWithString:self.currentItemValue];
            [scanner scanUpToString:@"\"" intoString:NULL];
            [scanner scanString:@"\"" intoString:NULL];
            [scanner scanUpToString:@"\"" intoString:&tmp];
            if ([scanner isAtEnd] == NO) {
                self.currentItem.mediaUrl = tmp;
            }
            [scanner scanString:@"\"" intoString:NULL];
        }
		self.currentItem.description = self.currentItemValue;
	}else if([elementName isEqualToString:@"link"]){
		self.currentItem.linkUrl = self.currentItemValue;
	}else if([elementName isEqualToString:@"guid"]){
		self.currentItem.guidUrl = self.currentItemValue;
	}else if([elementName isEqualToString:@"pubDate"]){
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
		self.currentItem.pubDate = [formatter dateFromString:self.currentItemValue];
	}else if([elementName isEqualToString:@"item"]){
		[[self rssItems] addObject:self.currentItem];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(nil != self.currentItemValue){
		[self.currentItemValue appendString:string];
	}
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	if(parseError.code != NSXMLParserDelegateAbortedParseError) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[(id)[self delegate] performSelectorOnMainThread:@selector(processHasErrors)
                                              withObject:nil
                                           waitUntilDone:NO];
	}
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[(id)[self delegate] performSelectorOnMainThread:@selector(processCompleted)
                                          withObject:nil
                                       waitUntilDone:NO];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void)dealloc{
	self.currentItem = nil;
	self.currentItemValue = nil;
	self.delegate = nil;
    
}

@end