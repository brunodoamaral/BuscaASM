//
//  BuscaASMNewViewController.m
//  BuscaASM
//
//  Created by Bruno Guberfain do Amaral on 7/7/12.
//
//

#import "BuscaASMNewViewController.h"
#import "BuscaASMEspecialidades.h"

@interface BuscaASMNewViewController () <UIPickerViewDataSource>

- (IBAction)onEspecialidade;
@property (weak, nonatomic) IBOutlet UIButton *btnEspecialidade;

@property (nonatomic, strong) BuscaASMEspecialidades *buscaAsmEspecialidades ;
@property (nonatomic, strong) NSMutableData *responseData ;


@end

@implementation BuscaASMNewViewController
@synthesize btnEspecialidade;
@synthesize buscaAsmEspecialidades = _buscaAsmEspecialidades ;
@synthesize responseData = _responseData ;

- (NSMutableData*) responseData
{
    if( ! _responseData ) {
        _responseData = [[NSMutableData alloc] init];
    }
    return _responseData ;
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
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.buscaasm.com/especialidades/"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *json = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    [btnEspecialidade setEnabled:YES];
    self.buscaAsmEspecialidades = [[BuscaASMEspecialidades alloc] initWithJsonString:json];
}

@end
