//
//  BuscaASMMapViewController.m
//  BuscaASM
//
//  Created by Bruno Guberfain do Amaral on 7/14/12.
//
//

#import "BuscaASMMapViewController.h"
#import "BuscaASMAssociado.h"
#import "SBJSON.h"
#import <MapKit/MapKit.h>

@interface BuscaASMMapViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate> {
    BOOL located ;
    BOOL reloadMapOnDoneConnection ;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableSet *associadosCarregados ;
@property (nonatomic, strong) NSMutableData *responseData ;

@end


@implementation BuscaASMMapViewController

@synthesize mapView = _mapView;
@synthesize especialidade = _especialidade ;
@synthesize associadosCarregados = _associadosCarregados ;
@synthesize responseData = _responseData ;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setMapView:nil];
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
            NSString *url = [[NSString alloc]initWithFormat:@"http://www.buscaasm.com/associados/locate?south=%.15g&north=%.15g&west=%.15g&east=%.15g&especialidade=%@", south, north, west, east, [self.especialidade stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]] ;
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
