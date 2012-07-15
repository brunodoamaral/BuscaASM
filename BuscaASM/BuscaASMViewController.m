//
//  BuscaASMViewController.m
//  BuscaASM
//
//  Created by Bruno Amaral on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BuscaASMViewController.h"
#import "BuscaASMEspecialidades.h"
#import "BuscaASMMapViewController.h"

@interface BuscaASMViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listEspecialidades;
@property (nonatomic, strong) BuscaASMEspecialidades *buscaAsmEspecialidades ;
@property (nonatomic, strong) NSMutableData *responseData ;
@end

@implementation BuscaASMViewController

@synthesize listEspecialidades = _listEspecialidades;
@synthesize buscaAsmEspecialidades = _buscaAsmEspecialidades ;
@synthesize responseData = _responseData ;

- (NSMutableData*) responseData
{
    if( ! _responseData ) {
        _responseData = [[NSMutableData alloc] init];
    }
    return _responseData ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.buscaasm.com/especialidades/"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)viewDidUnload
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setListEspecialidades:nil];
    [super viewDidUnload];
  
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"viewMap"]){
        BuscaASMMapViewController *mvc = (BuscaASMMapViewController *)[segue destinationViewController];
        mvc.especialidade = ((UITableViewCell*)sender).textLabel.text ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell ;
    if ( !self.buscaAsmEspecialidades ) {
        NSString *cellId = @"cellLoading" ;
        cell = [tableView dequeueReusableCellWithIdentifier:cellId] ;
        if ( ! cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
        }
        
    } else {
        NSString *cellId = @"cellEspecialidade" ;
        cell = [tableView dequeueReusableCellWithIdentifier:cellId] ;
        if ( ! cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
        }
        cell.textLabel.text = [self.buscaAsmEspecialidades.especialidades objectAtIndex:indexPath.row] ;
    }
    return cell ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( !self.buscaAsmEspecialidades ) return 1 ;
    return [self.buscaAsmEspecialidades.especialidades count] ;
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
    self.buscaAsmEspecialidades = [[BuscaASMEspecialidades alloc] initWithJsonString:json];
    [self.listEspecialidades reloadData];
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES ;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES ;
}

@end
