//
//  DribbblePlayer.h
//  LockerRoom
//
//  Created by Joni Salonen on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DribbblePlayer : NSObject {

}	

+(DribbblePlayer*)player:(NSString*)playerId;
+(NSArray*)followers:(NSString*)playerId;
+(NSArray*)following:(NSString*)playerId;
+(NSArray*)draftees:(NSString*)playerId;

+(NSArray*)shots:(NSString*)playerId;
+(NSArray*)following:(NSString*)playerId;
+(NSArray*)likes:(NSString*)playerId;


@end
