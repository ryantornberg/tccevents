//
//  SeatingChartWebViewController.m
//  TccEvents
//
//  Created by Ryan Tornberg on 5/13/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import "SeatingChartWebViewController.h"


@implementation SeatingChartWebViewController

@synthesize webView;

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
	[webView release];
	[seatingChartDetails release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	self.view = webView;
	self.webView.delegate = self;
	self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
	self.webView.scalesPageToFit = YES;
	self.navigationItem.title = @"TCC Seating Chart";
	NSString *myHTML = @"<html><head><title>TCC Seating</title><meta content='width=device-width; initial-scale=1.0; maximum-scale=3.0; user-scalable=1;' name='viewport' /></head><body><h1>Tucson Arena</h1><p><a href='http://cms3.tucsonaz.gov/sites/default/files/tcc/seatingcharts_arena_bg.gif'><img alt='Tucson Arena' style='max-width: 100%; width: 100%; height: auto;' src='http://cms3.tucsonaz.gov/sites/default/files/tcc/seatingcharts_arena_bg.gif' /></a></p><h1>Tucson Music Hall</h1><p><a href='http://cms3.tucsonaz.gov/sites/default/files/tcc/seatingcharts_musichall_bg.gif'><img alt='Tucson Music Hall' style='max-width: 100%; width: 100%; height: auto;' src='http://cms3.tucsonaz.gov/sites/default/files/tcc/seatingcharts_musichall_bg.gif' /></a></p><h1>Leo Rich Theater</h1><p><a href='http://cms3.tucsonaz.gov/sites/default/files/tcc/seatingcharts_leorich_bg.gif'><img alt='Leo Rich Theater' style='max-width: 100%; width: 100%; height: auto;' src='http://cms3.tucsonaz.gov/sites/default/files/tcc/seatingcharts_leorich_bg.gif' /></a></p></body></html>";
	[self.webView loadHTMLString:myHTML baseURL:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	webView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == YES);
	return YES;
}


//- (BOOL) webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//		NSURL *url = [request URL];
//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url absoluteString]]];
//		return NO;
//	}
//	return YES;
//}


@end
