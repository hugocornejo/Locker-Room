//
//  DribbbleShot.h
//  LockerRoom
//
//  Created by Joni Salonen on 6/21/11.
//  Copyright 2011 bilambee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DribbbleShot : NSObject {
	NSString *url;
	NSString *title;
	NSString *imageURL;
	NSString *playerUsername;
	NSString *localPath;
}

@property(retain) NSString *url;
@property(retain) NSString *title;
@property(retain) NSString *imageURL;
@property(retain) NSString *playerUsername;
@property(retain) NSString *localPath;

-(NSString*)finderComment;


@end
