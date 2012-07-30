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
	// Do any additional setup after loading the view.
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (CLLocationCoordinate2DMake(self.associado.latitude, self.associado.longitude), 100, 100);
    [self.mapView setRegion:region animated:NO];
    [self.mapView addAnnotation:self.associado] ;

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
//    if ( [field isEqualToString:@"latlon"] ) {
//        NSString *cellId = @"cellFieldMap" ;
//        cell = [tableView dequeueReusableCellWithIdentifier:cellId] ;
//        if ( ! cell ) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
//        }
//        MKMapView *mapView = (MKMapView *) [cell viewWithTag:1] ;
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (CLLocationCoordinate2DMake(self.associado.latitude, self.associado.longitude), 100, 100);
//        [mapView setRegion:region animated:NO];
//        [mapView addAnnotation:self.associado] ;
//    } else {
        NSString *cellId = @"cellField" ;
        cell = [tableView dequeueReusableCellWithIdentifier:cellId] ;
        if ( ! cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
        }
        
        cell.detailTextLabel.text = [self.associado valueForKey:field] ;
        cell.textLabel.text = field ;
//    }
    
    return cell ;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//    NSLog(@"row = %d",indexPath.row);
//    NSString *field = [self.associadoFields objectAtIndex:indexPath.row] ;
//    if ( [field isEqualToString:@"latlon"] ) {
//        return 150 ;
//    } else {
//        UITableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"cellField"] ;
//        UILabel *detailLabel = detailCell.detailTextLabel ;
//        CGSize requiredSize = [[self.associado valueForKey:field] sizeWithFont:detailLabel.font forWidth:detailLabel.frame.size.width lineBreakMode:detailLabel.lineBreakMode] ;
//        NSLog(@"height for %@ em %f é (%f, %f)", [self.associado valueForKey:field], detailLabel.frame.size.width, requiredSize.width, requiredSize.height);
//        return 20 + requiredSize.height ;
//    }
//}

@end
