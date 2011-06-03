//
//  DribbbleLikeDownloader.m
//  LockerRoom
//
//  Created by Joni Salonen on 5/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DribbbleLikeDownloader.h"


@implementation DribbbleLikeDownloader

+(DribbbleLikeDownloader*)initWithPlayer:(NSString *)playerId
{
	DribbbleLikeDownloader *obj = [DribbbleLikeDownloader alloc];
	obj->playerId = [playerId retain];
	obj->currentPage = 1;
	obj->numberOfPages = -1;
	obj->currentDownloads = 0;
	
	obj->currentData = nil;
	obj->targetDirectory = @"/tmp";
	return obj;
}

-(void)dealloc
{
	[playerId release];
	[currentData release];
	[super dealloc];
}

-(BOOL)downloadNextPage
{
	if (numberOfPages != -1 && currentPage >= numberOfPages) {
		NSLog(@"Finished downloading!");
		// download finished
		[currentDelegate performSelector:@selector(dribbbleLikeDownloaderFinished:) withObject:self];
		downloadInProgress = NO;
		return NO;
	} else if (currentDownloads > 0) {
		// Still downloading a page, hold your horses...
		downloadInProgress = YES;
		return YES;
	} else {
		// Go get that new page!
		currentPage++;
		NSString *urlStr = [NSString stringWithFormat:
							@"http://api.dribbble.com/players/%@/shots/likes?page=%d&per_page=30", 
							playerId, currentPage];
		NSURL *url = [NSURL URLWithString:urlStr];
		NSURLRequest *req = [NSURLRequest requestWithURL:url];
		NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
		if (conn) {
			NSLog(@"Downloading page %d", currentPage);
			if (currentData == nil) {
				currentData = [[NSMutableData dataWithLength:0] retain];
			} else {
				[currentData setLength:0];
			}
			downloadInProgress = YES; // download started
			[currentDelegate performSelector:@selector(dribbbleLikeDownloaderStarted:) withObject:self];
			return YES;
		} else {
			NSLog(@"Download failed on page %d", currentPage);
			[currentDelegate performSelector:@selector(dribbbleLikeDownloaderFinished:) withObject:self];
			downloadInProgress = NO; // download failed
			return NO;
		}
	}
}

-(void)downloadLikes:(id)delegate
{
	if (downloadInProgress == NO) {
		currentPage = 0;
		currentDelegate = delegate;
		[self downloadNextPage];
	}
}


#pragma mark Downloading metadata

-(NSString*)getFileName:(NSDictionary*)shot
{
	NSString *url = [shot objectForKey:@"url"];
	NSURL *imageUrl = [NSURL URLWithString:[shot objectForKey:@"image_url"]];
	NSString *lastBit = [[url lastPathComponent] stringByAppendingPathExtension:[imageUrl pathExtension]];
	return [targetDirectory stringByAppendingPathComponent:lastBit];
}


-(void)handleMetadataPage:(NSMutableDictionary*)page
{
	NSNumber *npages = [page objectForKey:@"pages"]; 
	numberOfPages = [npages intValue];
	
	// go get them likes!
	NSArray *likes = [page objectForKey:@"shots"];
	NSInteger downloadsStarted = 0;
	NSUInteger i, count = [likes count];
	for (i = 0; i < count; i++) {
		NSDictionary *obj = [likes objectAtIndex:i];
		NSString *fileName = [self getFileName:obj];
		NSFileManager *fm = [NSFileManager defaultManager];
		if (![fm fileExistsAtPath:fileName]) {
			NSURL *url = [NSURL URLWithString:[obj objectForKey:@"image_url"]];
			NSURLRequest *req = [NSURLRequest requestWithURL:url];
			NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:req delegate:self];
			if (download) {
				[download setDestination:fileName allowOverwrite:NO];
				downloadsStarted = downloadsStarted + 1;
				NSLog(@"Downloading shot %@ to %@", [obj objectForKey:@"title"], fileName);
			} else {
				NSLog(@"Failed to download shot %@", [obj objectForKey:@"title"]);
			}
		} else {
			NSLog(@"Already downloaded: %@", fileName);
		}
	}
	
	if (downloadsStarted == 0) {
		downloadInProgress = NO;
		NSLog(@"Already downloaded everything!");
		[currentDelegate performSelector:@selector(dribbbleLikeDownloaderFinished:) withObject:self];
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[currentData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[currentData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[currentData appendBytes:"\0" length:1];
	NSString *dataString = [NSString stringWithUTF8String:[currentData bytes]];
	if (dataString == nil) {
		NSLog(@"Failed to convert to UTF8: %s", [currentData bytes]);
	} else {
		NSMutableDictionary *jsonObj = [dataString JSONValue];
		[self handleMetadataPage:jsonObj];
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Download failed: %@", [error localizedDescription]);
}

#pragma mark Downloading shots

-(void)downloadDidBegin:(NSURLDownload *)download
{
//	NSLog(@"Download did begin");
	currentDownloads++;
}

-(void)downloadDidFinish:(NSURLDownload *)download
{
//	NSLog(@"Download finished: %@", [[download request] URL]);
	currentDownloads--;
	[self downloadNextPage];
}

-(void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
	NSLog(@"Download failed: %@", [error localizedDescription]);
	currentDownloads--;
	[self downloadNextPage];
}

@end
