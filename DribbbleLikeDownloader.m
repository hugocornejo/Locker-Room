//
//  DribbbleLikeDownloader.m
//  LockerRoom
//
//  Created by Joni Salonen on 5/30/11.
//  Copyright 2011 bilambee. All rights reserved.
//

#import "DribbbleLikeDownloader.h"
#import "DribbbleShot.h"
#import "Finder.h"

#include <sys/utsname.h>

@implementation DribbbleLikeDownloader

@synthesize checkAllPages;

-(DribbbleLikeDownloader*)initWithPlayer:(NSString *)player directory:(NSString *)target
{
	playerId = [player retain];
	currentPage = 1;
	numberOfPages = -1;
	currentDownloads = 0;
	
	currentData = nil;
	targetDirectory = [target retain];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:target]) {
		NSError *error = nil;
		[fm createDirectoryAtPath:target 
	  withIntermediateDirectories:YES 
					   attributes:nil 
							error:&error];
		if (error != nil) {
			NSLog(@"Unable to create target directory: %@", [error localizedDescription]);
		}
	}
	
	return self;
}

-(void)dealloc
{
	[playerId release];
	[targetDirectory release];
	[currentData release];
	[fileNameMap release];
	[super dealloc];
}

-(NSURLRequest*)requestWithURL:(NSURL*)url
{
	static NSString *userAgent = nil;
	if (userAgent == nil) {
		struct utsname name;
		if (uname(&name) == -1) {
			NSLog(@"uname: %s", strerror(errno));
			return nil;
		}
		
		NSBundle *mainBundle = [NSBundle mainBundle];
		NSString *appName = [mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
		NSString *appVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
		userAgent = [NSString stringWithFormat:@"%@/%@ OS: %s-%s/%s Contact: %@",
					 appName, appVersion,
					 name.sysname, name.machine, name.release,
					 @"http://bilambee.com/lockerroom"];
	}
	
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	[req setValue:userAgent forHTTPHeaderField:@"User-Agent"];
	return req;
}

-(BOOL)downloadNextPage
{
	if (numberOfPages != -1 && currentPage >= numberOfPages) {
		// download finished
		if (downloadInProgress != NO) {
			NSLog(@"Finished downloading!");
			[currentDelegate performSelector:@selector(dribbbleLikeDownloaderFinished:) withObject:self];
			downloadInProgress = NO;
		}
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
		NSURLRequest *req = [self requestWithURL:url];
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
			downloadInProgress = NO; // download failed
			[currentDelegate performSelector:@selector(dribbbleLikeDownloaderFinished:) withObject:self];
			return NO;
		}
	}
}

-(void)downloadLikes:(id)delegate
{
	if (downloadInProgress == NO) {
		currentPage = 0;
		currentDelegate = delegate;
		fileNameMap = [[NSMutableDictionary alloc] init];
		[self downloadNextPage];
	}
}


#pragma mark Downloading metadata

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
		DribbbleShot *shot = [[DribbbleShot alloc] initFromAPI:obj];
		NSString *fileName = [targetDirectory stringByAppendingPathComponent:shot.localPath];
		NSFileManager *fm = [NSFileManager defaultManager];
		if (![fm fileExistsAtPath:fileName]) {
			NSURLRequest *req = [self requestWithURL:shot.imageURL];
			NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:req delegate:self];
			if (download) {
				NSLog(@"Downloading %@", fileName);
				[fileNameMap setObject:shot forKey:shot.imageURL];
				[download setDestination:fileName allowOverwrite:NO];
				downloadsStarted = downloadsStarted + 1;
			} else {
				NSLog(@"Failed to download shot %@", [obj objectForKey:@"title"]);
			}
		} else {
			//NSLog(@"Already downloaded: %@", fileName);
		}
		[shot release];
	}
	
	if (downloadsStarted == 0) {
		if (checkAllPages) {
			// if no downloads are started, go to next page
			[self downloadNextPage];
		} else {
			downloadInProgress = NO;
			NSLog(@"Already downloaded everything!");
			[currentDelegate performSelector:@selector(dribbbleLikeDownloaderFinished:) withObject:self];
		}
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
	downloadInProgress = NO; // download failed
	[currentDelegate performSelector:@selector(dribbbleLikeDownloaderFinished:) withObject:self];
}

#pragma mark Downloading shots

-(void)downloadDidBegin:(NSURLDownload *)download
{
//	NSLog(@"Download did begin");
	currentDownloads++;
	[currentDelegate performSelector:@selector(dribbbleLikeDownloader:downloadDidBegin:) 
						  withObject:self 
						  withObject:download];
}


-(void)setFinderComment:(NSString*)comment forFile:(NSString*)path
{
	@try {
		static FinderApplication *finderApp = nil;
		if (finderApp == nil) {
			finderApp = [SBApplication applicationWithBundleIdentifier:@"com.apple.finder"];
		}
		NSURL *location = [NSURL fileURLWithPath:path];
		FinderItem *item = [[finderApp items] objectAtLocation:location];
		item.comment = comment;
	}
	@catch (NSException *ex) {
		NSLog(@"Unable to set finder comment for %@: %@", path, ex);
	}
}

-(void)downloadDidFinish:(NSURLDownload *)download
{
	NSURL *requestURL = [[download request] URL];
	DribbbleShot *shot = [fileNameMap objectForKey:requestURL];
	NSString *localPath = [targetDirectory stringByAppendingPathComponent:shot.localPath];
	[self setFinderComment:[shot finderComment] forFile:localPath];
	[fileNameMap removeObjectForKey:requestURL];

	[download release];
	currentDownloads--;
	[self downloadNextPage];
}

-(void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
	// Release memory allocated for dribbble shot data
	NSURL *requestURL = [[download request] URL];
	[fileNameMap removeObjectForKey:requestURL];

	NSLog(@"Error downloading %@: %@", [[download request] URL], [error localizedDescription]);
	[download release];
	currentDownloads--;
	[self downloadNextPage];
}

@end
