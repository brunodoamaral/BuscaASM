//
//  BuscaASMMapViewController.h
//  BuscaASM
//
//  Created by Bruno Guberfain do Amaral on 7/14/12.
//
//

#import <UIKit/UIKit.h>

@interface BuscaASMMapViewController : UIViewController

- (void) hideHelp ;

@property (nonatomic, strong) NSString * category ;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarTitle;

@end
