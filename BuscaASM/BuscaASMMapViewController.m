//
//  BuscaASMMapViewController.m
//  BuscaASM
//
//  Created by Bruno Guberfain do Amaral on 7/14/12.
//
//

#import "BuscaASMMapViewController.h"
#import "BuscaASMAssociado.h"
#import "BuscaASMDetalheViewController.h"
#import "SBJSON.h"
#import <MapKit/MapKit.h>

@interface BuscaASMMapViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate> {
    BOOL located ;
    BOOL reloadMapOnDoneConnection ;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableSet *associadosCarregados ;
@property (nonatomic, strong) NSMutableData *responseData ;
@property (weak, nonatomic) IBOutlet UIView *helpButton;
@property (strong, nonatomic) UIPopoverController* popController ;

@end


@implementation BuscaASMMapViewController

@synthesize mapView = _mapView;
@synthesize category = _category ;
@synthesize toolBar = _tollBar;
@synthesize toolBarTitle = _toolBarTitle;
@synthesize associadosCarregados = _associadosCarregados ;
@synthesize responseData = _responseData ;
@synthesize popController = _popController ;

- (UIPopoverController *)popController
{
    if ( !_popController && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        UIViewController *popHelpView = [self.storyboard instantiateViewControllerWithIdentifier:@"helpView"] ;
        _popController = [[UIPopoverController alloc] initWithContentViewController:popHelpView];
    } ;
    return _popController ;
}

- (void)setCategory:(NSString *)category
{
    if ( _category != category ) {
        _category = category ;
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.associadosCarregados removeAllObjects];
        if( self.view.window )
            [self updateMap:self.mapView];
    }
}

- (NSMutableData*) responseData
{
    if( ! _responseData ) {
        _responseData = [[NSMutableData alloc] init];
    }
    return _responseData ;
}

-(NSSet*) associadosCarregados
{
    if ( ! _associadosCarregados ) {
        _associadosCarregados = [[NSMutableSet alloc] init] ;
    }
    
    return _associadosCarregados ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    located = NO ;
    reloadMapOnDoneConnection = NO ;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureCaptured:)];
    pinch.delegate = self;
    [self.mapView addGestureRecognizer:pinch];
        
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCaptured:)];
    pan.delegate = self;
    [self.mapView addGestureRecognizer:pan];
    
    if (self.mapView.userLocation.location) {
        [self mapView:self.mapView didUpdateUserLocation:self.mapView.userLocation];
    }
}

- (void)hideHelp
{
    [self.popController dismissPopoverAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ( UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ) {
        UIBarButtonItem *toolBar = [self.toolBar.items objectAtIndex:0] ;
        [self.popController presentPopoverFromBarButtonItem:toolBar permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES] ;
    };
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setToolBar:nil];
    [self setToolBarTitle:nil];
    [self setHelpButton:nil];
    [super viewDidUnload];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"location = %@", userLocation.location) ;
    if ( ! located ) {
        if ( userLocation.location ) {
            located = YES ;
            double precision = MAX(userLocation.location.horizontalAccuracy, 1000) ;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, precision, precision);
            [self.mapView setRegion:region animated:NO];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    located = YES ;
}

- (void) updateMap:(MKMapView *)mapView
{
    NSLog(@"updateMap center = %f / %f", mapView.region.center.latitude, mapView.region.center.longitude);
    NSLog(@"updateMap span = %f / %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
    
    if ( located ) {
        if ( self.responseData.length == 0 ) {
            NSLog(@"Will make a new connection...");
            // Connection available
            reloadMapOnDoneConnection = NO ;
            double north = mapView.region.center.latitude+mapView.region.span.latitudeDelta/2 ;
            double south = mapView.region.center.latitude-mapView.region.span.latitudeDelta/2 ;
            double west = mapView.region.center.longitude-mapView.region.span.longitudeDelta/2 ;
            double east = mapView.region.center.longitude+mapView.region.span.longitudeDelta/2 ;
            NSString *url = [[NSString alloc]initWithFormat:@"http://www.buscaasm.com/associados/locate?south=%.15g&north=%.15g&west=%.15g&east=%.15g&especialidade=%@", south, north, west, east, [self.category stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]] ;
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        } else {
            NSLog(@"A connection is already running");
            reloadMapOnDoneConnection = YES ;
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
//    NSLog(@"will center = %f / %f", mapView.region.center.latitude, mapView.region.center.longitude);
//    NSLog(@"will span = %f / %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    NSLog(@"did center = %f / %f", mapView.region.center.latitude, mapView.region.center.longitude);
//    NSLog(@"did span = %f / %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
    [self updateMap: mapView];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ( [annotation isKindOfClass:[MKUserLocation class]] )
        return nil ;
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
    } else {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"viewDetail" sender:view.annotation] ;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"viewDetail"] ) {
        if ( [sender isKindOfClass:[BuscaASMAssociado class]] ) {
            BuscaASMAssociado *associado = (BuscaASMAssociado*) sender ;
            NSLog(@"nome = %@", associado.nome) ;
            BuscaASMDetalheViewController *dvc = (BuscaASMDetalheViewController*) [segue destinationViewController] ;
            dvc.associado = associado ;
        }
    }
}

#pragma mark Gesture Recognizers

- (void)pinchGestureCaptured:(UIPinchGestureRecognizer*)gesture{
    if(UIGestureRecognizerStateEnded == gesture.state){
        ///////////////////[self doWhatYouWouldDoInRegionDidChangeAnimated];
    }
}

- (void)panGestureCaptured:(UIPanGestureRecognizer*)gesture{
    
    if(UIGestureRecognizerStateEnded == gesture.state){
        NSLog(@"Pan captured");
        [self updateMap: self.mapView];
    }
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:   (UITouch *)touch{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer   shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer    *)otherGestureRecognizer{
    return YES;
}

#pragma mark Conecxão

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",error) ;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    reloadMapOnDoneConnection = NO ;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *json = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    [self.responseData setLength:0];
    
    NSArray *associados = [json JSONValue];
    NSLog(@"%d associados encontrados", [associados count]);
    for (NSDictionary* associadoDic in associados) {
        BuscaASMAssociado *associado = [[BuscaASMAssociado alloc] initWithDictionary:[associadoDic objectForKey:@"associado"]];
        if ( ![self.associadosCarregados containsObject:associado] ) {
            [self.associadosCarregados addObject:associado] ;
            
            [self.mapView addAnnotation:associado] ;
        }
    }
    if ( reloadMapOnDoneConnection ) {
        [self updateMap:self.mapView];
    }
}

@end
