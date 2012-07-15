//
//  BuscaASMListaMedicosViewController.m
//  BuscaASM
//
//  Created by Bruno Amaral on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BuscaASMListaMedicosViewController.h"

@interface BuscaASMListaMedicosViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listaMedicos;

@end

@implementation BuscaASMListaMedicosViewController
@synthesize listaMedicos;

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
}

- (void)viewDidUnload
{
    [self setListaMedicos:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellMedico" ;
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId] ;
    if ( ! cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Médico %d", indexPath.row] ;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Rua Tal, %d", indexPath.row] ;
    return cell ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20 ;
}

@end
