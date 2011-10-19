//
//  RootViewController.m
//  TccEvents
//
//  Created by Ryan Tornberg on 3/8/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import "RootViewController.h"
#import "DetailWebViewController.h"
#import "NSDate+RFC3339.h"
#import "NSString+RFC3339.h"
#import "JSON.h"
#import "TccEventsAppDelegate.h"
#import "ContactUsWebViewController.h"
#import "ParkingMapWebViewController.h"
#import "SeatingChartWebViewController.h"
#import "SVProgressHUD.h"
#import "Reachability.h"

@implementation RootViewController

@synthesize managedObjectContext;
@synthesize gcalEvents;
@synthesize sections;
@synthesize connection;

#pragma mark -
#pragma mark View lifecycle


- (void) viewDidLoad {
    [super viewDidLoad];
	
	self.navigationController.toolbarHidden= NO;
	self.title = @"TCC Events";
	
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPageAction:)];
	UIBarButtonItem *parkingButton = [[UIBarButtonItem alloc] initWithTitle:@"Parking" style:UIBarButtonItemStyleBordered target:self action:@selector(parkingPageAction:)];
	UIBarButtonItem *contactUsButton = [[UIBarButtonItem alloc] initWithTitle:@"Contact Us" style:UIBarButtonItemStyleBordered target:self action:@selector(contactUsPageAction:)];
	UIBarButtonItem *seatingChartButton = [[UIBarButtonItem alloc] initWithTitle:@"Seating Chart" style:UIBarButtonItemStyleBordered target:self action:@selector(seatingChartPageAction:)];
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	NSArray* toolbarItems = [NSArray arrayWithObjects: flexibleSpace, refreshButton, flexibleSpace, seatingChartButton, flexibleSpace, parkingButton, flexibleSpace, contactUsButton, flexibleSpace, nil];
	self.toolbarItems = toolbarItems;
	[refreshButton release];
	[parkingButton release];
	[contactUsButton release];
	[seatingChartButton release];
	[flexibleSpace release];
	if (managedObjectContext == nil) 
	{ 
		managedObjectContext = [(TccEventsAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}

	hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	internetReach = [Reachability reachabilityForInternetConnection];
//		[hostReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
	}



#pragma mark -
#pragma mark Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
//	return 1;
	return [[self.sections allKeys] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section]] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
	NSDate *date = [NSDate dateFromShortDateString:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section]];
	NSString *title = [NSString stringFromRFC3339Date:date];
    return title;
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}

	UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
//	UILabel *lblDetails = (UILabel *)[cell viewWithTag:2];
	
//	Event *event = [gcalEvents objectAtIndex:[indexPath row]];
	Event *event = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	
	NSString *title = [event title]; 
	
	title = [NSString stringWithFormat:@"%@: %@",[NSString timeFromDate:[event timeStamp]], title];
	
//	NSString *details = [event details];
//	NSString *start = [NSString stringFromRFC3339Date:[event startDate]];

	cell.textLabel.text = title;
//	cell.textLabel.font = [UIFont italicSystemFontOfSize:cell.textLabel.font.pointSize];
//	cell.detailTextLabel.text = details;
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	lblTitle.text = title;
//	lblDetails.text = details;
	
	return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == YES);
	return YES;
}



#pragma mark -
#pragma mark Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	NSUInteger row = 0;
	NSUInteger sect = indexPath.section;
	for (NSUInteger i = 0; i < sect; ++ i)
		row += [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:i]] count];
	row += indexPath.row;

	Event *event = [gcalEvents objectAtIndex:row];
	DetailWebViewController *detailWebViewController = [[DetailWebViewController alloc] initWithNibName:@"DetailWebView" bundle:[NSBundle mainBundle]];
	NSString *details = [event details];
	
//	NSLog(@"row=%d, count=%d, list is%@ nil",indexPath.row,[self.gcalEvents count],(self.gcalEvents==nil ? @"" : @" NOT"));
	
	if ([details length]== 0) {
		details = @"There are no details for this event.";
	}
	
	detailWebViewController.eventDetails = details;
	detailWebViewController.eventName = [event title];
	NSString *dateString = [NSString stringFromRFC3339Date:[event timeStamp]];
	detailWebViewController.eventDate = dateString;

	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
	[newBackButton release];
	
	[self.navigationController pushViewController:detailWebViewController animated:YES];
	[detailWebViewController release];
	detailWebViewController = nil;
}



#pragma mark -
#pragma mark Custom Methods



- (void)parkingPageAction:(id)sender {
	
	ParkingMapWebViewController *parkingMapWebViewController = [[ParkingMapWebViewController alloc] initWithNibName:@"ParkingMapWebView" bundle:[NSBundle mainBundle]];
	
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
	
	[newBackButton release];
	
	[self.navigationController pushViewController:parkingMapWebViewController animated:YES];
	[parkingMapWebViewController release];
	parkingMapWebViewController = nil;
}


- (void)seatingChartPageAction:(id)sender {
	
	SeatingChartWebViewController *seatingChartWebViewController = [[SeatingChartWebViewController alloc] initWithNibName:@"SeatingChartWebView" bundle:[NSBundle mainBundle]];
	
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
	
	[newBackButton release];
	
	[self.navigationController pushViewController:seatingChartWebViewController animated:YES];
	[seatingChartWebViewController release];
	seatingChartWebViewController = nil;
}


- (void)contactUsPageAction:(id)sender {
	
	ContactUsWebViewController *contactUsWebViewController = [[ContactUsWebViewController alloc] initWithNibName:@"ContactUsWebView" bundle:[NSBundle mainBundle]];
	
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
	
	[newBackButton release];
	
	[self.navigationController pushViewController:contactUsWebViewController animated:YES];
	[contactUsWebViewController release];
	contactUsWebViewController = nil;
	
	
//	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//	[activityIndicator startAnimating];
//	UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
//	[activityIndicator release];
//	self.navigationItem.rightBarButtonItem = activityItem;
//	[activityItem release];
//	
//	UIAlertView *alert = [[UIAlertView alloc]
//						  initWithTitle: @"contact"
//						  message: @"contact us page action"
//						  delegate: self
//						  cancelButtonTitle:@"OK"
//						  otherButtonTitles:nil];
//	[alert show];
//	[alert release];
//	[activityIndicator stopAnimating];
}


- (void)refreshPageAction:(id)sender;
{
	internetReach = [Reachability reachabilityForInternetConnection];
	//		[hostReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
}


- (void) fetchData {
	
	// Define our table/entity to use
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
	
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	// Define how we will sort the records
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	// Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
	
//	NSManagedObjectContext *context = [self managedObjectContext];
//	NSFetchRequest *fetch = [[[NSFetchRequest alloc] init] autorelease];
//	[fetch setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
//	NSArray *results = [context executeFetchRequest:fetch error:nil];
//	NSMutableArray *mutableResults = [NSMutableArray arrayWithArray: results];
	
	if (!mutableResults) {
		// Handle the error.
		// This is a serious error and should advise the user to restart the application
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	// ******** THIS CODE IS CAUSING EXC_BAD_ACCESS
	NSMutableArray *discardedItems = [NSMutableArray array];
	for (NSUInteger x = 0; x < [mutableResults count]; x++) {
		//		NSDictionary *anEvent = [allItems objectAtIndex:x];
		//		NSString *eventName = [anEvent objectForKey:@"title"];
		
		Event *anEvent = [mutableResults objectAtIndex:x];
		NSString *eventName = [anEvent title];
		if ([eventName length] == 0) {
			[discardedItems addObject:anEvent];
		}
	}
	[mutableResults removeObjectsInArray:discardedItems];
	
	// Save our fetched data to an array
	[self setGcalEvents: mutableResults];
	[mutableResults release];
	
	NSMutableDictionary *sectionList = [[NSMutableDictionary alloc] init];
    self.sections = sectionList;
	[sectionList release];
    
    BOOL found;
    
    // Loop through the books and create our keys
    for (Event *event in self.gcalEvents) {
        NSDate *c = [event timeStamp];
        
        found = NO;
		
		for (NSString *dt in [self.sections allKeys]) {
			if ([[NSString stringFromDateYYYYMMDD:c] isEqualToString:dt]) {
				found = YES;
			}
		}

        if (!found)
        {   
			NSMutableArray *tmp = [[NSMutableArray alloc] init];
            [self.sections setValue:tmp forKey:[NSString stringFromDateYYYYMMDD:c]];
			[tmp release];
        }
    }
	
    // Loop again and sort the books into their respective keys
    for (Event *event in self.gcalEvents)
    {
//        [[self.sections objectForKey:[[event title] substringToIndex:1]] addObject:event];
//		[[self.sections objectForKey:[event timeStamp]] addObject:event];
		[[self.sections objectForKey:[NSString stringFromDateYYYYMMDD:[event timeStamp]]] addObject:event];
    }    
    
    // Sort each section array
//    for (NSString *key in [self.sections allKeys])
//    {
//		[[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:YES]]];
//    }    
	
	
	[self.tableView reloadData];
	
//	RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]];
//	
//	rootViewController.gcalEvents = mutableFetchResults;
//	[self.navigationController pushViewController:rootViewController animated:YES];
//	[rootViewController release];
//	rootViewController = nil;  
	
}


- (void) clearEvents {
	NSManagedObjectContext *context = [self managedObjectContext];
	NSFetchRequest *fetch = [[[NSFetchRequest alloc] init] autorelease];
	[fetch setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
	NSArray *result = [context executeFetchRequest:fetch error:nil];
	for (id event in result) {
//		NSLog(@"Event Title: %@", [event title]);
//		if([event title] == nil) {
			[context deleteObject:event];			
//		}
	}
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// This is a serious error saying the record could not be saved.
		// Advise the user to restart the application
		
		//				UIAlertView *alert = [[UIAlertView alloc]
		//									  initWithTitle: @"error saving"
		//									  message: @"test message"
		//									  delegate: self
		//									  cancelButtonTitle:@"OK"
		//									  otherButtonTitles:nil];
		//				[alert show];
		//				[alert release];
		NSLog(@"Error: %@", error);
	} else {
//		NSLog(@"EVENTS DELETED");
	}
}


- (void) fetchJson
{	
	responseData = [[NSMutableData data] retain];
	gcalEvents = [[NSMutableArray array] retain]; 
	NSString *startDateMinString = [NSString stringFromTodaysDate];
	NSMutableString *url = [NSMutableString stringWithString:@"https://www.google.com/calendar/feeds/tucsonconv%40gmail.com/public/full?v=2&alt=jsonc&singleevents=true&ctz=America/Phoenix&orderby=starttime&sortorder=ascending&fields=items(details,title,when,id)&max-results=75&start-min="];
	[url appendString:startDateMinString];
//	[url appendString:@"2011-05-10T00:00:00-07:00"];

	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//	[url release];

//	&futureevents=true
//	https://www.google.com/calendar/feeds/tucsonconv%40gmail.com/public/full?v=2&alt=jsonc&singleevents=true&ctz=America/Phoenix&orderby=starttime&sortorder=ascending&fields=items(title,when,id)&start-min=
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void) saveData {
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	NSDictionary *results = [responseString JSONValue];
	[responseString release];
	NSDictionary *responseDict = [results objectForKey:@"data"]; // Get your dictionary
	NSMutableArray  *allItems = [responseDict objectForKey:@"items"]; 
	
	for (NSUInteger x = 0; x < [allItems count]; x++) {
		NSDictionary *anEvent = [allItems objectAtIndex:x];
		NSString *eventDetails= [anEvent objectForKey:@"details"];
		NSString *eventName = [anEvent objectForKey:@"title"];
		
		NSMutableArray *whenArray = [anEvent objectForKey:@"when"];
		NSDictionary *whenDict = [whenArray objectAtIndex:0];
		NSString *startDateString = [whenDict objectForKey:@"start"];
		NSDate *startDate = [NSDate dateFromRFC3339String:startDateString];
		if(startDate == nil) {
			startDate = [NSDate dateFromShortDateString:startDateString];
		}
		
		Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
		[event setTitle:eventName];
		[event setDetails:eventDetails];
		[event setTimeStamp:startDate];
	}
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// This is a serious error saying the record could not be saved.
		// Advise the user to restart the application
		
		//				UIAlertView *alert = [[UIAlertView alloc]
		//									  initWithTitle: @"error saving"
		//									  message: @"test message"
		//									  delegate: self
		//									  cancelButtonTitle:@"OK"
		//									  otherButtonTitles:nil];
		//				[alert show];
		//				[alert release];
		NSLog(@"Error: %@", error);
	} else {
//		NSLog(@"EVENTS SAVED");
	}
}


//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
////	NSLog(@"expected:%d, got:%d", UIWebViewNavigationTypeLinkClicked, navigationType);
//	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//		NSURL *url = [request URL];
//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url absoluteString]]];
//		return NO;
//	}
//	return YES;
//}



#pragma mark -
#pragma mark NSURLConnection delegate methods



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
//	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//	NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if (self.connection) {
		[self.connection release];
		self.connection = nil;
	}
	[self clearEvents];
	[self saveData];
	[self fetchData];

	[self dismiss];
}



#pragma mark -
#pragma mark Reachability



- (void) updateInterfaceWithReachability: (Reachability *) curReach
{
    if(curReach == internetReach)
	{
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
		switch (netStatus) {
			case NotReachable:{
				
				UIAlertView * alert  = [[UIAlertView alloc] initWithTitle:@"Cannot Get Events" message:@"No Internet connection detected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
				[alert show];
				break;
				
			default:{
				//				UIAlertView * alert  = [[UIAlertView alloc] initWithTitle:@"Network good" message:@"Network is up and running." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
				//				[alert show];
				[self show];
				[self fetchJson];
				break;
			}
			}
		}
    }
}

//Called by Reachability whenever status changes.
//- (void) reachabilityChanged: (NSNotification* )note
//{
//	Reachability* curReach = [note object];
//	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
//	[self updateInterfaceWithReachability: curReach];
//}



#pragma mark -
#pragma mark SBProgressHUD methods


- (void) show {
	[SVProgressHUD show];
}

- (void) dismiss {
	[SVProgressHUD dismiss];
}


#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[gcalEvents release];
	[sections release];
	[responseData release];
	[managedObjectContext release];
    [super dealloc];
}


@end

