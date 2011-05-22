//
//  LockerRoomAppDelegate.m
//  LockerRoom
//
//  Created by Joni Salonen on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LockerRoomAppDelegate.h"
#import "DribbblePlayer.h"

@implementation LockerRoomAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	updateTimer = [[NSTimer
					scheduledTimerWithTimeInterval:60.0
					target:self
					selector:@selector(downloadLikes)
					userInfo:nil
					repeats:YES] retain];
	
//	[updateTimer fireDate];
}

-(void)dealloc
{
	[updateTimer release];
	[super dealloc];
}


-(void)downloadLikes
{
	[menulet setBusy:YES];
	NSLog(@"Downloading Dribbble likes...");
	
	NSArray *likes = [DribbblePlayer likes:@"simplebits"];
	[menulet setBusy:NO];
	
	NSLog(@"%s", [likes description]);
	
	//NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
	//NSURLRequest *req = [NSURLRequest requestWithURL:url];
	//NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:req delegate:self];
	//if (download) {
	//	[download setDestination:@"/tmp/goog" allowOverwrite:YES];
	//} else {
	//download failed
	//}
	
	//	[NSURLConnection connectionWithRequest:req delegate:<#(id)delegate#>];
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
	[menulet setBusy:NO];
	
    // Release the connection.
    [download release];
	
    // Inform the user.
    NSLog(@"Download failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)downloadDidFinish:(NSURLDownload *)download
{
	[menulet setBusy:NO];
	
    // Release the connection.
    [download release];
	
    // Do something with the data.
    NSLog(@"%@",@"downloadDidFinish");
}

@end
