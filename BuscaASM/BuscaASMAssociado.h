//
//  BuscaASMMedico.h
//  BuscaASM
//
//  Created by Bruno Guberfain do Amaral on 7/14/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BuscaASMAssociado : NSObject <MKAnnotation>

- (BuscaASMAssociado*) initWithDictionary:(NSDictionary*) associado ;

@property (nonatomic, strong) NSString *bairro ;
@property (nonatomic, strong) NSString *cep ;
@property (nonatomic, strong) NSString *cidade ;
@property (nonatomic, strong) NSString *endereco ;
@property (nonatomic, strong) NSArray *especialidades ;
@property (nonatomic, strong) NSString *estado ;
@property (nonatomic) long identificador ;
@property (nonatomic, strong) NSString *nome ;
@property (nonatomic, strong) NSString *telefone ;
@property (nonatomic, strong) NSString *tipo ;
@property (nonatomic) double latitude ;
@property (nonatomic) double longitude ;

#pragma  mark From MKAnnotation

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;

@end
