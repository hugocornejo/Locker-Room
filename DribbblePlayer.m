//
//  DribbblePlayer.m
//  LockerRoom
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DribbblePlayer.h"
#import "DribbbleShot.h"
#import "DribbbleAPI.h"

@implementation DribbblePlayer

+(DribbblePlayer*)player:(NSString*)playerId
{
	return nil;
}

+(NSArray*)followers:(NSString*)playerId
{
	return nil;
}

+(NSArray*)following:(NSString*)playerId
{
	return nil;
}

+(NSArray*)draftees:(NSString*)playerId
{
	return nil;
}

+(NSArray*)shots:(NSString*)playerId
{
	return nil;
}

+(NSArray*)shotsFollowing:(NSString*)playerId
{
	return nil;
}

+(NSArray*)likes:(NSString*)playerId
{
	NSError *error = nil;
	int page = 1;
	int pages = 1;
	NSMutableArray *likes = [NSMutableArray array];
	do {
		NSString *method = [NSString stringWithFormat:@"players/%@/shots/likes?page=%d&per_page=30", playerId, page];
		DribbbleAPI *api = [[DribbbleAPI initWithMethod:method] autorelease];
		NSDictionary *results = [api syncCall:&error];
		if (results == nil) {
			NSLog(@"Error from API call: %s", [error description]);
			pages = -1;
		} else {
			pages = [results objectForKey:@"pages"];
			// FIXME check if number of pages changes during the loop
			page = page + 1;
			NSArray *shots = [results objectForKey:@"shots"];
			[likes addObjectsFromArray:shots];
			NSUInteger i, count = [shots count];
			for (i = 0; i < count; i++) {
				NSObject * obj = [shots objectAtIndex:i];
				NSLog(@"%@", [obj description]);
			}
		}
	} while (page < pages);
	return likes;
}

-(void)dribbleCallDidFinish:(NSMutableDictionary*)obj
{
}


@end
