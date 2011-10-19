#import "DateSectionTitlesAppDelegate.h"
#import "RootViewController.h"
#import "JSON.h"
#import "Event.h"
#import "RegexKitLite.h"
#import "NSDate+RFC3339.h"

@interface DateSectionTitlesAppDelegate (CoreDateStack)
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end


@implementation DateSectionTitlesAppDelegate

@synthesize gcalEvents;

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	[self fetchJson];
	
	RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
	rootViewController.managedObjectContext = self.managedObjectContext;
	
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	
	[rootViewController release];
	
	[window addSubview: [self.navigationController view]];
	[window makeKeyAndVisible];


}


- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"DateSectionTitles.sqlite"]];
	
	BOOL firstRun = YES;	
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeUrl path] isDirectory:NULL]) {
		firstRun = YES;		
	}
	
	NSError *error = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    

    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Custom data methods


- (void) clearEvents {
	
//	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];	
//	[context setPersistentStoreCoordinator:persistentStoreCoordinator];	
	
	NSManagedObjectContext *context = [self managedObjectContext];
	NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
	
	NSError *error = nil;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();	
	}
	
	for (id event in fetchedObjects)
		[context deleteObject:event];
	
	[context save:NULL];
	[context release];
}


- (void) fetchJson
{	
	responseData = [[NSMutableData data] retain];
	gcalEvents = [NSMutableArray array];
	//https://www.google.com/calendar/feeds/tucsonconv%40gmail.com/public/full?v=2&alt=jsonc&singleevents=true&start-min=2011-04-06T00%3A00%3A00.000-07%3A00
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com/calendar/feeds/tucsonconv%40gmail.com/public/full?v=2&alt=jsonc&singleevents=true&ctz=America/Phoenix&orderby=starttime&sortorder=ascending"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void) saveData {
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	NSDictionary *results = [responseString JSONValue];
	NSDictionary *responseDict = [results objectForKey:@"data"]; // Get your dictionary
	NSMutableArray  *allItems = [responseDict objectForKey:@"items"]; 
	
	NSMutableArray *discardedItems = [NSMutableArray array];
	for (int x = 0; x < [allItems count]; x++) {
		NSDictionary *anEvent = [allItems objectAtIndex:x];
		NSString *eventName = [anEvent objectForKey:@"title"];
		if ([eventName length] == 0) {
			[discardedItems addObject:anEvent];
		}
	}
	[allItems removeObjectsInArray:discardedItems];
	
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];	
	[context setPersistentStoreCoordinator:persistentStoreCoordinator];	
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];

	for (int x = 0; x < [allItems count]; x++) {
		NSDictionary *anEvent = [allItems objectAtIndex:x];
//		NSString *eventDetails= [anEvent objectForKey:@"details"];
		NSString *eventName = [anEvent objectForKey:@"title"];
		NSMutableArray *whenArray = [anEvent objectForKey:@"when"];
		NSDictionary *whenDict = [whenArray objectAtIndex:0];
		NSString *startDateString = [whenDict objectForKey:@"start"];
		NSDate *startDate = [NSDate dateFromRFC3339String:startDateString];
		if(startDate == nil) {
			startDate = [NSDate dateFromShortDateString:startDateString];
		}
		Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
		[event setTitle:eventName];
	// [event setDetails:eventDetails];
		[event setTimeStamp:startDate];
	}
	
	[context save:NULL];
	[context release];
}


#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	[self clearEvents];
	[self saveData];
	RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
//	[rootViewController.tableView reloadData];
	[rootViewController reloadData];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {

    [gcalEvents release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

