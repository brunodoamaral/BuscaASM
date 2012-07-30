//
//  BuscaASMDetalheViewController.m
//  BuscaASM
//
//  Created by Bruno Guberfain do Amaral on 7/29/12.
//
//

#import "BuscaASMDetalheViewController.h"
#import <MapKit/MapKit.h>

@interface BuscaASMDetalheViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *fields;
@property (strong, nonatomic, readonly) NSArray *associadoFields ;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation BuscaASMDetalheViewController

@synthesize fields = _fields;
@synthesize associado = _associado ;
@synthesize associadoFields = _associadoFields ;
@synthesize mapView = _mapView;

- (NSArray *)associadoFields
{
    if (! _associadoFields ) {
        // Define a ordem de exibição do campos na tela
        _associadoFields = [[NSArray alloc] initWithObjects:
//                            @"latlon",
                            @"nome",
                            @"telefone",
                            @"endereco",
                            @"bairro",
                            @"cep",
                            @"cidade",
                            @"estado",
//                            @"especialidades",
//                            @"identificador",
//                            @"tipo",
//                            @"latitude",
//                            @"longitude",
                            nil ] ;
    }
    return _associadoFields ;
}

- (void)setAssociado:(BuscaASMAssociado *)associado
{
    if ( _associado != associado ) {
        [self.mapView removeAnnotations:self.mapView.annotations] ;
        _associado = associado ; 
        [self updateMap] ;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) updateMap
{
    if ( self.associado ) {
        [self.mapView addAnnotation:self.associado] ;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (CLLocationCoordinate2DMake(self.associado.latitude, self.associado.longitude), 100, 100);
        [self.mapView setRegion:region animated:NO];
        [self.fields reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self updateMap];
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
    [self setFields:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.associadoFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *field = [self.associadoFields objectAtIndex:indexPath.row] ;
    UITableViewCell * cell ;

    NSString *cellId = @"cellField" ;
    cell = [tableView dequeueReusableCellWithIdentifier:cellId] ;
    if ( ! cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
    }
    
    cell.detailTextLabel.text = [self.associado valueForKey:field] ;
    cell.textLabel.text = field ;
    
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *field = [self.associadoFields objectAtIndex:indexPath.row] ;

    UITableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"cellField"] ;
    UILabel *detailLabel = detailCell.detailTextLabel ;
    CGRect frame = detailLabel.frame ;
    frame.size.width = 200 ;
    detailLabel.frame = frame ;
    detailLabel.text = [self.associado valueForKey:field] ;
    [detailLabel sizeToFit] ;

    return detailLabel.frame.size.height + 22 ;
}

@end
