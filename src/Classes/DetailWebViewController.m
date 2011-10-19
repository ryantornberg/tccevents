//
//  DetailWebView.m
//  TccEvents
//
//  Created by Ryan Tornberg on 4/25/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import "DetailWebViewController.h"
//#import "RegexKitLite.h"

@implementation DetailWebViewController

@synthesize webView;
@synthesize eventDetails;
@synthesize eventName;
@synthesize eventDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[eventDetails release];
	[eventName release];
	[eventDate release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.view = webView;
	self.webView.delegate = self;
	self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
	self.navigationItem.title = eventName;
	[webView loadHTMLString:[self fixHtml:eventDetails] baseURL:nil];
//	[webView loadHTMLString:eventDetails baseURL:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[webView release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == YES);
	return YES;
}


#pragma mark -
#pragma mark private methods


- (NSString *) fixHtml:(NSString *)unformattedHtml 
{
	NSMutableString *formattedHtml;	
	formattedHtml = [[unformattedHtml stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"] mutableCopy];
	
//	NSString *regEx = @"<a href=[^>]*>(.+?)</a\\s*>";
//	NSString *match = [eventDetails stringByMatching:regEx];
//	if (match == nil) {
//		regEx = @"(http:\"?)[a-zA-Z0-9:/.?=%-_]*";
//		match = [eventDetails stringByMatching:regEx];
//		if(match != nil) {
//			formattedHtml = [[formattedHtml stringByReplacingOccurrencesOfString:match withString:[self getFormattedUrl:match]] mutableCopy];
//		}
//	}
	return formattedHtml;
}
//
//
//- (NSString *) getFormattedUrl:(NSString *)unformattedUrl 
//{
//	NSString *regEx = @"(http:\"?)[a-zA-Z0-9:/.?=%-_]*";
//	NSString *strippedUrl = [unformattedUrl stringByMatching:regEx];
//	NSString *ticketMaster = [unformattedUrl stringByMatching:@"ticketmaster"];
//	NSString *formattedHtml;
//	NSString *anchorText;
//	if (ticketMaster == nil) {
//		anchorText = strippedUrl;
//	} else{
//		anchorText = @"Buy Tickets";
//	}
//	formattedHtml = [NSString stringWithFormat:@"%@%@%@%@%@", @"<a href=", strippedUrl, @">", anchorText , @"</a>"];
//	return formattedHtml;
//}


- (BOOL) webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *url = [request URL];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url absoluteString]]];
		return NO;
	}
	return YES;
}

@end
