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
#import "BuscaASMBoxesView.h"
#import "BuscaASMTouchableImageView.h"
#import <AudioToolbox/AudioServices.h>

@interface BuscaASMViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAccelerometerDelegate, BuscaASMTouchableImageViewTouch>

@property (weak, nonatomic) IBOutlet UITableView *listEspecialidades;
@property (weak, nonatomic) IBOutlet BuscaASMBoxesView *leftBoxes;
@property (weak, nonatomic) IBOutlet BuscaASMBoxesView *rightBoxes;
@property (weak, nonatomic) IBOutlet BuscaASMTouchableImageView *imageLogo;

@end

@implementation BuscaASMViewController

@synthesize listEspecialidades = _listEspecialidades;
@synthesize leftBoxes = _leftBoxes;
@synthesize rightBoxes = _rightBoxes;
@synthesize imageLogo = _imageLogo;
@synthesize especialidade = _especialidade ;

- (BuscaASMEspecialidade *)especialidade
{
    if ( ! _especialidade ) {
        _especialidade = [BuscaASMEspecialidades rootEspecialidade];
    }
    
    return _especialidade ;
}

- (void)setEspecialidade:(BuscaASMEspecialidade *)especialidade
{
    _especialidade = especialidade ;
    self.navigationItem.title = especialidade.name ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.imageLogo.delegateLongTouch = self ;
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidUnload
{
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setListEspecialidades:nil];
    [self setLeftBoxes:nil];
    [self setRightBoxes:nil];
    [self setImageLogo:nil];
    [super viewDidUnload];
  
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //Configure and start accelerometer
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60.0)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];

}

- (void) viewWillDisappear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender
{
    if([[segue identifier] isEqualToString:@"viewMap"]){
        // Ver Mapa
        BuscaASMMapViewController *mvc = (BuscaASMMapViewController *)[segue destinationViewController];
        
        NSIndexPath *indexPath = [(UITableView *)sender.superview indexPathForCell: sender];
        BuscaASMEspecialidade * especialidade = [self.especialidade.children objectAtIndex:indexPath.row] ;

        mvc.category = [especialidade.categories anyObject];
        mvc.navigationItem.title = especialidade.name ;

    } else if ( [segue.identifier isEqualToString:@"viewEspecialidade"] ) {
        // Navegar na lista
        BuscaASMViewController *vc = (BuscaASMViewController *)[segue destinationViewController];
        
        NSIndexPath *indexPath = [(UITableView *)sender.superview indexPathForCell: sender];
        vc.especialidade = [self.especialidade.children objectAtIndex:indexPath.row] ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell ;

    NSString *cellId = @"cellEspecialidade" ;
    cell = [tableView dequeueReusableCellWithIdentifier:cellId] ;
    if ( ! cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
    }
    cell.textLabel.text = ((BuscaASMEspecialidade*) [self.especialidade.children objectAtIndex:indexPath.row]).name ;

    return cell ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.especialidade.children count] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuscaASMEspecialidade * especialidade = (BuscaASMEspecialidade*) [self.especialidade.children objectAtIndex:indexPath.row];
    if ( [especialidade.children count] == 0 ) {
        [self performSegueWithIdentifier:@"viewMap" sender:[tableView cellForRowAtIndexPath:indexPath] ] ;
    } else {
        [self performSegueWithIdentifier:@"viewEspecialidade" sender:[tableView cellForRowAtIndexPath:indexPath] ] ;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    [self.leftBoxes accelerometer:accelerometer didAccelerate:acceleration];
    [self.rightBoxes accelerometer:accelerometer didAccelerate:acceleration];
}

- (void)onLongTouchImage:(BuscaASMTouchableImageView *)image
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [self.leftBoxes setAtive:YES] ;
    [self.rightBoxes setAtive:YES] ;
}

@end
