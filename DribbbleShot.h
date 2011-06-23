//
//  DribbbleShot.h
//  LockerRoom
//
//  Created by Joni Salonen on 6/21/11.
//  Copyright 2011 bilambee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DribbbleShot : NSObject {
	NSURL *url;
	NSString *title;
	NSURL *imageURL;
	NSString *playerUsername;
	NSString *localPath;
}

@property(retain) NSURL *url;
@property(retain) NSString *title;
@property(retain) NSURL *imageURL;
@property(retain) NSString *playerUsername;
@property(retain,readonly) NSString *localPath;

-(NSString*)finderComment;
-(DribbbleShot*)initFromAPI:(NSDictionary*)shot;

@end
