//
//  DribbbleShot.m
//  LockerRoom
//
//  Created by Joni Salonen on 6/21/11.
//  Copyright 2011 bilambee. All rights reserved.
//

#import "DribbbleShot.h"


@implementation DribbbleShot

@synthesize url;
@synthesize title;
@synthesize imageURL;
@synthesize playerUsername;
@synthesize localPath;

-(void)dealloc
{
	[url release];
	[title release];
	[imageURL release];
	[playerUsername release];
	[localPath release];
	[super dealloc];
}

-(NSString*)finderComment
{
	NSString *comment = [NSString stringWithFormat:@"\"%@\" by %@\n%@",
						 title, playerUsername, url];
	return comment;
}

@end
