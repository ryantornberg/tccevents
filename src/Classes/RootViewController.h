//
//  RootViewController.h
//  TccEvents
//
//  Created by Ryan Tornberg on 3/8/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@class Reachability;
@interface RootViewController : UITableViewController {
	NSManagedObjectContext *managedObjectContext;
	NSMutableData *responseData;
	NSMutableArray *gcalEvents;
	NSMutableDictionary *sections;
	
	Reachability *internetReach;
    Reachability *hostReach;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *gcalEvents;
@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSURLConnection *connection;

- (void) saveData;
- (void) fetchData;
- (void) clearEvents;
- (void) fetchJson;
- (IBAction) show;
- (IBAction) dismiss;
- (void) updateInterfaceWithReachability: (Reachability *) curReach;


@end
