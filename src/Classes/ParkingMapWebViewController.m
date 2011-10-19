//
//  ParkingMapWebViewController.m
//  TccEvents
//
//  Created by Ryan Tornberg on 5/10/11.
//  Copyright 2011 City of Tucson. All rights reserved.
//

#import "ParkingMapWebViewController.h"


@implementation ParkingMapWebViewController

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
	[parkingMapDetails release];
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
	self.navigationItem.title = @"TCC Parking";	
	NSString *html = @"<html><head><title>TCC Parking</title><meta content='width=device-width; initial-scale=1.0; maximum-scale=3.0; user-scalable=1;' name='viewport' /></head><body><p>At the Tucson Convention Center we have plenty of parking. We provide parking for all events and we offer monthly parking passes for those of us that work downtown. For current rates, give us a call.</p><p>If you know your event needs additional assisted parking, let us know, we can accommodate your needs.<br />&nbsp;</p><p><a href='http://cms3.tucsonaz.gov/sites/default/files/tcc/Parking_Map.jpg'><img alt='' style='max-width: 100%; width: 100%; height: auto;' src='http://cms3.tucsonaz.gov/sites/default/files/tcc/Parking_Map.jpg' /></a></p><table border='1' bordercolor='#8f86b8' cellpadding='5' cellspacing='0' width='100%'><tr><td bgcolor='#d8dee1' class='Link_Headers' colspan='3'><strong>Lot Capacities</strong></td></tr><tr><td class='Link_Headers'><strong>PARKING LOT</strong></td><td class='Link_Headers'><strong>LOT NAME</strong>&nbsp;&nbsp;&nbsp;</td><td class='Link_Headers'><strong>NUMBER OF SPACES</strong></td></tr><tr><td width='110'><div align='center'>A, B, C</div></td><td>TCC Lots</td><td>1,060</td></tr><tr><td width='110'><div align='center'>2</div></td><td>Private Lot</td><td>400</td></tr><tr><td width='110'><div align='center'>3</div></td><td>Private Lot</td><td>200</td></tr><tr><td width='110'><div align='center'>4</div></td><td>Hotel Arizona Garage</td><td>316</td></tr><tr><td width='110'><div align='center'>5</div></td><td>La Placita Garage</td><td>500</td></tr><tr><td width='110'><div align='center'>6</div></td><td>Cathedral Lot</td><td>100</td></tr><tr><td width='110'><div align='center'>7</div></td><td>Greyhound Lot</td><td>100</td></tr><tr><td width='110'><div align='center'>8</div></td><td>Catalina Lot</td><td>200</td></tr><tr><td width='110'><div align='center'>9</div></td><td>El Presidio Lot</td><td>575</td></tr><tr><td width='110'><div align='center'>10</div></td><td>City/State Garage</td><td>1,256</td></tr><tr><td><div align='center'>11</div></td><td>Pennington St. Garage</td><td>750</td></tr></table><p>&nbsp;</p><h2><strong><span class='Link_Headers'>Bus / Limousine Parking</span></strong></h2><p>Bus and limousine parking is easily accommodated for any event need. Contact the Parking Supervisor for arrangements.</p><p>&nbsp;</p><h2><strong><span class='Link_Headers'>Rules of the lots</span></strong></h2><p>No overnight parking is permitted unless related to an event and approved by Center management</p><p>No oversize trucks and trailers allowed in parking lots</p><p>The passing out of flyers or selling of merchandise is strictly prohibited by outside groups or individuals without the permission of Center management</p><p>No consumption of alcoholic beverages will be permitted in the parking lots</p><p>No tailgating or similar parties will be permitted in the parking lots</p><p>Valid parking passes must be clearly displayed</p><p>Tucson Convention Center is not responsible for any stolen property.</p><p>&nbsp;</p><h2><strong><span class='Link_Headers'>Parking Staff</span></strong></h2><p>William (Bill) Ricketts<br />Parking Manager<br />(520) 837-4777<br /><a href='mailto:william.ricketts@tucsonaz.gov'>william.ricketts@tucsonaz.gov</a></p></body></html>";
	[self.webView loadHTMLString:html baseURL:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == YES);
	return YES;
}


#pragma mark -
#pragma mark Custom methods


//- (BOOL) webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//		NSURL *url = [request URL];
//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url absoluteString]]];
//		return NO;
//	}
//	return YES;
//}


@end
