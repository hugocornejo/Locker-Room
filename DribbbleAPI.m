//
//  DribbbleAPI.m
//  LockerRoom
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DribbbleAPI.h"
#import "JSON.h"


@implementation DribbbleAPI

+(DribbbleAPI*)initWithMethod:(NSString *)m
{
	DribbbleAPI *instance = [DribbbleAPI alloc];
	instance->method = [m retain];
	return instance;
}

-(void) dealloc
{
	[method release];
	[currentData release];
	[currentDelegate release];
	
	[super dealloc];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[currentData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[currentData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *dataString = [NSString stringWithUTF8String:[currentData bytes]];
	NSMutableDictionary *jsonObj = [dataString JSONValue];
	[currentDelegate dribbbleCallDidFinish:jsonObj];
	[currentData release];
	currentData = nil;
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[currentDelegate dribbleCallDidFailWithError:error];
	[currentData release];
	currentData = nil;
}

-(void) call:(id)delegate
{
	NSString *apiURL = [@"http://api.dribbble.com/" stringByAppendingString:method];
	NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:apiURL]];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	if (conn) {
		currentDelegate = [delegate retain];
		currentData = [NSMutableData dataWithLength:0];
	} else {
		NSLog(@"Connection failed");
	}
}

-(NSDictionary*)syncCall:(NSError**)error
{
	NSString *apiURL = [@"http://api.dribbble.com/" stringByAppendingString:method];
	NSString *dataString = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiURL]
													encoding:NSUTF8StringEncoding
													   error:error];
	if (dataString == nil) {
		return nil;
	} else {
		NSMutableDictionary *jsonObj = [dataString JSONValue];
		return jsonObj;
	}
}

@end
