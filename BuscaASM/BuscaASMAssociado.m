//
//  BuscaASMMedico.m
//  BuscaASM
//
//  Created by Bruno Guberfain do Amaral on 7/14/12.
//
//

#import "BuscaASMAssociado.h"

@implementation BuscaASMAssociado

@synthesize bairro = _bairro ;
@synthesize cep = _cep ;
@synthesize cidade = _cidade ;
@synthesize endereco = _endereco ;
@synthesize especialidades = _especialidades ;
@synthesize estado = _estado ;
@synthesize identificador = _identificador ;
@synthesize nome = _nome;
@synthesize telefone = _telefone ;
@synthesize tipo = _tipo ;
@synthesize latitude = _latitude ;
@synthesize longitude = _longitude ;

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude) ;
}

- (NSString *)title
{
    return self.nome ;
}

- (BuscaASMAssociado*) initWithDictionary:(NSDictionary*) associado
{
    if ( (self = [super init]) )
    {
        self.bairro = [associado objectForKey:@"bairro"];
        self.cep = [associado objectForKey:@"cep"];
        self.cidade = [associado objectForKey:@"cidade"];
        self.endereco = [associado objectForKey:@"endereco"];
        self.especialidades = [associado objectForKey:@"especialidades"];
        self.estado = [associado objectForKey:@"estado"];
        self.identificador = [(NSNumber*)[associado objectForKey:@"id"] longValue];
        self.nome = [associado objectForKey:@"nome"];
        self.telefone = [associado objectForKey:@"telefone"];
        self.tipo = [associado objectForKey:@"tipo"];
        self.latitude = [(NSNumber*)[associado objectForKey:@"latitude"] doubleValue];
        self.longitude = [(NSNumber*)[associado objectForKey:@"longitude"] doubleValue];
    }
    
    return self ;
}

-(BOOL) isEqual:(id)object
{
    if ( [object isKindOfClass:[BuscaASMAssociado class]] ) {
        return self.identificador == ((BuscaASMAssociado*)object).identificador ;
    } else {
        return NO ;
    }
}

- (NSUInteger)hash
{
    return [[[NSNumber alloc] initWithLong:self.identificador] hash];
}


@end
