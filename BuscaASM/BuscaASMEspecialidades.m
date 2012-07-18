//
//  BuscaASMEspecialidades.m
//  BuscaASM
//
//  Created by Bruno Amaral on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BuscaASMEspecialidades.h"
#import "SBJSON.h"

@implementation BuscaASMEspecialidade

@synthesize identifier = _identifier ;
@synthesize name = _name ;
@synthesize children = _children ;
@synthesize categories = _categories ;
@synthesize parent = _parent ;

- (NSArray *)children
{
    if ( !_children ) _children = [[NSMutableArray alloc]init];
    return _children ;
}

- (NSMutableSet *)categories
{
    if ( !_categories ) _categories = [[NSMutableSet alloc]init];
    return _categories ;
}

- (void)setParent:(BuscaASMEspecialidade *)parent
{
    _parent = parent ;
}

- (BuscaASMEspecialidade*) initWith:(int) identifier andName:(NSString*)name ;
{
    if ( (self=[super init]) != nil )
    {
        _name = name ;
        _identifier = identifier ;
    }
    
    return self ;
}

- (void)addChildren:(BuscaASMEspecialidade *)child
{
    [self.children addObject:child];
    child.parent = self ;
    [self.categories addObjectsFromArray:[child.categories allObjects]] ;
}

- (void)addCategory:(NSString *)category
{
    [self.categories addObject:category];
    [self updateParentCategories];
}

- (void)addCategories:(NSArray *)categories
{
    [self.categories addObjectsFromArray:categories];
    [self updateParentCategories];
}

- (void) updateParentCategories
{
    BuscaASMEspecialidade *aParent = self.parent ;
    while ( aParent ) {
        [aParent addCategories:[self.categories allObjects]];
        aParent = aParent.parent ;
    }
}

@end

@implementation BuscaASMEspecialidades

static BuscaASMEspecialidade * _rootEspecialidade = nil  ;

+ (BuscaASMEspecialidade*) rootEspecialidade ;
{
    if ( _rootEspecialidade ) return _rootEspecialidade ;
    
    NSString *especialidades = @"{\"title\":\"root\",\"identifier\":0,\"categories\":[],\"children\":[{\"title\":\"Clínicas Ambulatoriais\",\"identifier\":121,\"categories\":[],\"children\":[{\"title\":\"Consultas Ambulatórias em diversas Especialidades\",\"identifier\":122,\"categories\":[\"CLIN  ATEND  AMBULATORIAL\"],\"children\":[]},{\"title\":\"Dependência Química\",\"identifier\":125,\"categories\":[\"HOSP/CLIN ESPEC DEP QUIMI\"],\"children\":[]}]},{\"title\":\"Emergências\",\"identifier\":98,\"categories\":[],\"children\":[{\"title\":\"Médicas\",\"identifier\":99,\"categories\":[],\"children\":[{\"title\":\"Emergência Ortopédica\",\"identifier\":103,\"categories\":[\"HOSP/CLIN EMERG ORTOPEDIC\"],\"children\":[]},{\"title\":\"Emergência Pediátrica\",\"identifier\":102,\"categories\":[\"HOSP/CLIN EMERG PEDIATRIC\"],\"children\":[]},{\"title\":\"Emergências Cardiológicas\",\"identifier\":104,\"categories\":[\"HOSP/CLIN ESPEC CARDIOLOG\"],\"children\":[]},{\"title\":\"Emergências Psiquiátricas\",\"identifier\":105,\"categories\":[\"HOSP/CLIN ESPEC PSIQUIATR\"],\"children\":[]},{\"title\":\"Hospital com Serviço de Emergência\",\"identifier\":101,\"categories\":[\"HOSP/CLIN ESPEC EMERGENCI\"],\"children\":[]}]},{\"title\":\"Odontológicas\",\"identifier\":100,\"categories\":[\"CLINICA EMERGENCIA ODONTO\"],\"children\":[]}]},{\"title\":\"Especialidades Médicas\",\"identifier\":1,\"categories\":[],\"children\":[{\"title\":\"Acupuntura\",\"identifier\":130,\"categories\":[\"ACUPUNTURA\"],\"children\":[]},{\"title\":\"Alergia e Imunologia\",\"identifier\":2,\"categories\":[],\"children\":[{\"title\":\"Alergia e Imunologia\",\"identifier\":41,\"categories\":[\"ALERGIA E IMUNOLOGIA\",\"SERV ALERGIA/IMUNOLOGIA\"],\"children\":[]},{\"title\":\"Pediátrica\",\"identifier\":42,\"categories\":[\"ALERGIA/IMUNO PEDIATRICA\"],\"children\":[]}]},{\"title\":\"Anestesiologia\",\"identifier\":3,\"categories\":[\"ANESTESIOLOGIA\",\"SERV ANESTESIA -COOP/CLIN\"],\"children\":[]},{\"title\":\"Angiologia\",\"identifier\":4,\"categories\":[\"ANGIOLOGIA\"],\"children\":[]},{\"title\":\"Cardiologia\",\"identifier\":5,\"categories\":[\"CARDIOLOGIA\"],\"children\":[]},{\"title\":\"Cirurgia Cardiovascular\",\"identifier\":6,\"categories\":[\"CIR CARDIOVASCULAR\"],\"children\":[]},{\"title\":\"Cirurgia Crânio Maxilofacial\",\"identifier\":7,\"categories\":[],\"children\":[]},{\"title\":\"Cirurgia da Cabeça e Pescoço\",\"identifier\":8,\"categories\":[\"CIR DA CABECA E PESCOCO\",\"SERV CIR CABECA E PESCOCO\"],\"children\":[]},{\"title\":\"Cirurgia de Mão\",\"identifier\":135,\"categories\":[\"CIRURGIA DE MAO\"],\"children\":[]},{\"title\":\"Cirurgia Geral\",\"identifier\":9,\"categories\":[],\"children\":[{\"title\":\"Cirurgia Geral\",\"identifier\":43,\"categories\":[\"CIR GERAL\",\"SERV DE CIRURGIA GERAL\"],\"children\":[]},{\"title\":\"Videolaparoscopia\",\"identifier\":44,\"categories\":[\"CIR VIDEOLAPAROSCOPICA\",\"SERV CIR VIDEOLAPAROSCOP\"],\"children\":[]}]},{\"title\":\"Cirurgia Pediátrica\",\"identifier\":10,\"categories\":[\"CIR PEDIATRICA\"],\"children\":[]},{\"title\":\"Cirurgia Plástica Reparadora\",\"identifier\":11,\"categories\":[],\"children\":[{\"title\":\"Cirurgia da Mão\",\"identifier\":46,\"categories\":[\"CIRURGIA DE MAO\"],\"children\":[]},{\"title\":\"Cirurgia Plástica Reparadora\",\"identifier\":45,\"categories\":[\"CIR PLASTICA REPARADORA\",\"SERV DE CIRURGIA PLASTICA\"],\"children\":[]}]},{\"title\":\"Cirurgia Torácica\",\"identifier\":12,\"categories\":[\"CIR TORACICA\"],\"children\":[]},{\"title\":\"Cirurgia Vascular Periférica\",\"identifier\":13,\"categories\":[\"CIRURGIA VASCULAR\",\"SER.ANGIOL.E CIR.VASC.PER\"],\"children\":[]},{\"title\":\"Clínica Médica\",\"identifier\":14,\"categories\":[\"CLINICA MEDICA\"],\"children\":[]},{\"title\":\"Dermatologia\",\"identifier\":15,\"categories\":[\"DERMATOLOGIA\",\"SERV DE DERMATOLOGIA\"],\"children\":[]},{\"title\":\"Endocrinologia\",\"identifier\":16,\"categories\":[\"ENDOCRINOLOGIA METABOLOGI\",\"SERV DE ENDOCRINOLOGIA\"],\"children\":[]},{\"title\":\"Endoscopia Digestiva\",\"identifier\":17,\"categories\":[\"ENDOSCOPIA\"],\"children\":[]},{\"title\":\"Gastroenterologia\",\"identifier\":18,\"categories\":[\"GASTROENTEROLOGIA\",\"SERV GASTRO/PROCTOLOGIA\"],\"children\":[]},{\"title\":\"Genética\",\"identifier\":19,\"categories\":[\"GENETICA MEDICA\"],\"children\":[]},{\"title\":\"Geriatria e Gerontologia\",\"identifier\":20,\"categories\":[\"GERIATRIA\"],\"children\":[]},{\"title\":\"Ginecologia\",\"identifier\":21,\"categories\":[],\"children\":[{\"title\":\"Ginecologia\",\"identifier\":47,\"categories\":[\"GINECOLOGIA\",\"SERV DE GINECO E OBST\"],\"children\":[]},{\"title\":\"Videolaparoscopia\",\"identifier\":48,\"categories\":[\"CIR VIDEOLAPAROSCOPICA\",\"SERV CIR VIDEOLAPAROSCOP\"],\"children\":[]}]},{\"title\":\"Hematologia\",\"identifier\":22,\"categories\":[\"HEMATOLOGIA E HEMOTERAPIA\"],\"children\":[]},{\"title\":\"Homeopatia\",\"identifier\":23,\"categories\":[],\"children\":[{\"title\":\"Homeopatia\",\"identifier\":49,\"categories\":[\"HOMEOPATIA\"],\"children\":[]},{\"title\":\"Pediátrica\",\"identifier\":50,\"categories\":[\"HOMEOPATIA PEDIATRICA\"],\"children\":[]}]},{\"title\":\"Infectologia\",\"identifier\":24,\"categories\":[\"INFECTOLOGIA\"],\"children\":[]},{\"title\":\"Mastologia\",\"identifier\":25,\"categories\":[\"MASTOLOGIA\"],\"children\":[]},{\"title\":\"Nefrologia\",\"identifier\":26,\"categories\":[\"NEFROLOGIA\"],\"children\":[]},{\"title\":\"Neurocirurgia\",\"identifier\":27,\"categories\":[\"NEUROCIRURGIA\",\"SERV DE NEUROCIRURGIA\"],\"children\":[]},{\"title\":\"Neurologia\",\"identifier\":28,\"categories\":[],\"children\":[{\"title\":\"Neurologia\",\"identifier\":51,\"categories\":[\"NEUROLOGIA\",\"SERV DE NEUROLOGIA\"],\"children\":[]},{\"title\":\"Pediátrica\",\"identifier\":52,\"categories\":[\"NEUROLOGIA PEDIATRICA\"],\"children\":[]}]},{\"title\":\"Nutrologia\",\"identifier\":29,\"categories\":[],\"children\":[]},{\"title\":\"Obstetrícia\",\"identifier\":30,\"categories\":[\"OBSTETRICIA\",\"SERV DE GINECO E OBST\"],\"children\":[]},{\"title\":\"Oftalmologia\",\"identifier\":31,\"categories\":[\"OFTALMOLOGIA\",\"SERV DE OFTALMOLOGIA\"],\"children\":[]},{\"title\":\"Oncologia / Cancerologia\",\"identifier\":32,\"categories\":[],\"children\":[{\"title\":\"Oncologia / Cancerologia\",\"identifier\":53,\"categories\":[\"CANCEROLOGIA/ONCOLOGIA\",\"SERV DE ONCOLOGIA\"],\"children\":[]},{\"title\":\"Pediátrica\",\"identifier\":54,\"categories\":[\"ONCOLOGIA  PEDIATRICA\"],\"children\":[]}]},{\"title\":\"Ortopedia e Traumatologia\",\"identifier\":33,\"categories\":[],\"children\":[{\"title\":\"Cirurgia da mão\",\"identifier\":57,\"categories\":[\"CIRURGIA DE MAO\"],\"children\":[]},{\"title\":\"Ortopedia e Traumatologia\",\"identifier\":55,\"categories\":[\"ORTOPEDIA E TRAUMATOLOGIA\",\"SERV ORTOP TRAUMATOLOGIA\"],\"children\":[]},{\"title\":\"Pediátrica\",\"identifier\":56,\"categories\":[\"ORTOPEDIA  PEDIATRICA\"],\"children\":[]}]},{\"title\":\"Otorrinolaringologia\",\"identifier\":34,\"categories\":[\"OTORRINOLARINGOLOGIA\",\"SERV DE OTORRINO\"],\"children\":[]},{\"title\":\"Pediatria e puericultura\",\"identifier\":35,\"categories\":[\"PEDIATRIA\",\"SERV DE PEDIATRIA E PUER.\"],\"children\":[]},{\"title\":\"Pneumologia\",\"identifier\":36,\"categories\":[\"PNEUMOLOGIA\",\"SERV DE PNEUMOLOGIA\"],\"children\":[]},{\"title\":\"Proctologia\",\"identifier\":37,\"categories\":[\"COLOPROCTOLOGIA\"],\"children\":[]},{\"title\":\"Psiquiatria\",\"identifier\":38,\"categories\":[\"PSIQUIATRIA\"],\"children\":[]},{\"title\":\"Reumatologia\",\"identifier\":39,\"categories\":[\"REUMATOLOGIA\",\"SERV DE REUMATOLOGIA\"],\"children\":[]},{\"title\":\"Urologia\",\"identifier\":40,\"categories\":[\"SERV DE UROLOGIA\",\"UROLOGIA\"],\"children\":[]}]},{\"title\":\"Especialidades Odontológicas\",\"identifier\":81,\"categories\":[],\"children\":[{\"title\":\"Bucomaxilofacial\",\"identifier\":82,\"categories\":[\"CIR TRAUM BUCO-MAXILO-FAC\"],\"children\":[]},{\"title\":\"Dentista Clínico\",\"identifier\":83,\"categories\":[\"CLINICA ODONTOLOGICA\"],\"children\":[]},{\"title\":\"Endodontia\",\"identifier\":84,\"categories\":[\"ENDODONTIA\"],\"children\":[]},{\"title\":\"Estomatologia/patologia bucal\",\"identifier\":90,\"categories\":[\"ESTOMATOLOGIA/PAT BUCAL\"],\"children\":[]},{\"title\":\"Implantodontia\",\"identifier\":131,\"categories\":[\"IMPLANTODONTIA\"],\"children\":[]},{\"title\":\"Odontologia Pacientes Especiais\",\"identifier\":91,\"categories\":[\"ODONTO PACIENTE ESPECIAL\"],\"children\":[]},{\"title\":\"Odontopediatria\",\"identifier\":85,\"categories\":[\"ODONTOPEDIATRIA\"],\"children\":[]},{\"title\":\"Ortodontia /Ortopedia maxilar\",\"identifier\":86,\"categories\":[\"ORTO FUNC DOS MAXILARES\",\"ORTODONTIA\"],\"children\":[]},{\"title\":\"Periodontia\",\"identifier\":87,\"categories\":[\"PERIODONTIA\"],\"children\":[]},{\"title\":\"Prótese dentária\",\"identifier\":88,\"categories\":[\"PROTESE DENTARIA\"],\"children\":[]},{\"title\":\"Radiologia Odontológica\",\"identifier\":89,\"categories\":[\"IMAGINOL/RADIOLOGIA ODONT\"],\"children\":[]}]},{\"title\":\"Hospitais\",\"identifier\":106,\"categories\":[],\"children\":[{\"title\":\"Hospital com Serviço de Emergência\",\"identifier\":129,\"categories\":[\"HOSP/CLIN ESPEC EMERGENCI\"],\"children\":[]},{\"title\":\"Hospital de Cardiologia\",\"identifier\":108,\"categories\":[\"HOSP/CLIN ESPEC CARDIOLOG\"],\"children\":[]},{\"title\":\"Hospital de Cirurgia Geral\",\"identifier\":120,\"categories\":[\"HOSP/CLIN CIRURGIA GERAL\"],\"children\":[]},{\"title\":\"Hospital de Obstetrícia\",\"identifier\":109,\"categories\":[],\"children\":[{\"title\":\"Hospital de Neonatologia\",\"identifier\":111,\"categories\":[\"NEONATAL/TERAPIA INTENSIV\"],\"children\":[]},{\"title\":\"Hospital de Obstetrícia\",\"identifier\":110,\"categories\":[\"HOSP/CLIN ESPEC OBSTETRIC\"],\"children\":[]}]},{\"title\":\"Hospital de Oftalmologia\",\"identifier\":112,\"categories\":[\"HOSP/CLIN ESPEC OFTALMO\"],\"children\":[]},{\"title\":\"Hospital de Oncologia\",\"identifier\":119,\"categories\":[\"HOSP/CLIN ESPEC ONCOLOGIA\"],\"children\":[]},{\"title\":\"Hospital de Ortopedia\",\"identifier\":113,\"categories\":[\"HOSP/CLIN ESPEC ORTOPEDIA\"],\"children\":[]},{\"title\":\"Hospital de Otorrinolaringologia\",\"identifier\":114,\"categories\":[\"HOSP/CLIN ESPEC OTORRINO\"],\"children\":[]},{\"title\":\"Hospital de Pediatria\",\"identifier\":115,\"categories\":[],\"children\":[{\"title\":\"Hospital de Neonatologia\",\"identifier\":117,\"categories\":[\"NEONATAL/TERAPIA INTENSIV\"],\"children\":[]},{\"title\":\"Hospital de Pediatria\",\"identifier\":116,\"categories\":[\"HOSP/CLIN ESPEC PEDIATRIA\"],\"children\":[]}]},{\"title\":\"Hospital de Psiquiatria\",\"identifier\":118,\"categories\":[\"HOSP/CLIN ESPEC PSIQUIATR\"],\"children\":[]},{\"title\":\"Hospital Geral\",\"identifier\":107,\"categories\":[\"HOSP/CLIN ATEND GERAL\"],\"children\":[]}]},{\"title\":\"Nutrição\",\"identifier\":132,\"categories\":[],\"children\":[{\"title\":\"Nutrição\",\"identifier\":133,\"categories\":[\"NUTRICAO\"],\"children\":[]}]},{\"title\":\"Programa de Assistência Domiciliar\",\"identifier\":124,\"categories\":[],\"children\":[]},{\"title\":\"Remoções\",\"identifier\":79,\"categories\":[],\"children\":[{\"title\":\"Remoções em ambulância\",\"identifier\":80,\"categories\":[\"SERV DE REMOCAO TERRESTRE\"],\"children\":[]}]},{\"title\":\"Serviços de Diagnóstico e Terapêutica\",\"identifier\":58,\"categories\":[],\"children\":[{\"title\":\"Audiometria e Otoneurologia\",\"identifier\":59,\"categories\":[\"SERV AUDIOMETRIA/OTONEURO\"],\"children\":[]},{\"title\":\"Citopatologia\",\"identifier\":67,\"categories\":[\"SERV DE CITOPATOLOGIA\"],\"children\":[]},{\"title\":\"Densitometria Óssea\",\"identifier\":77,\"categories\":[\"SERV DENSITOMETRIA OSSEA\"],\"children\":[]},{\"title\":\"EEG/Neurofisiologia\",\"identifier\":60,\"categories\":[\"SERV EEG/NEUROFISIOLOGIA\"],\"children\":[]},{\"title\":\"Endoscopia Digestiva\",\"identifier\":78,\"categories\":[\"ENDOSCOPIA\"],\"children\":[]},{\"title\":\"Exames de Cardiologia\",\"identifier\":70,\"categories\":[\"METODOS COMPL CARDIOLOGIA\"],\"children\":[]},{\"title\":\"Exames de Oftalmologia\",\"identifier\":71,\"categories\":[\"METODOS COMPL OFTALMOLOGI\"],\"children\":[]},{\"title\":\"Hemodinâmica\",\"identifier\":63,\"categories\":[\"SERVICO DE HEMODINAMICA\"],\"children\":[]},{\"title\":\"Hemodiálise\",\"identifier\":62,\"categories\":[\"SERVICO DE HEMODIALISE\"],\"children\":[]},{\"title\":\"Hemoterapia\",\"identifier\":64,\"categories\":[\"SERV.HEMOTERAP/HEMATOLOG.\"],\"children\":[]},{\"title\":\"Laboratório de Anatomia Patológica\",\"identifier\":66,\"categories\":[\"LAB ANATOMIA PATOLOGICA\",\"LAB.A.CLI/AN.PAT/RADIOIMU\"],\"children\":[]},{\"title\":\"Laboratório de Análises Clínicas\",\"identifier\":65,\"categories\":[\"LAB.A.CLI/AN.PAT/RADIOIMU\",\"LAB.DE ANALISES CLINICAS\"],\"children\":[]},{\"title\":\"Laringoscopia/Broncoscopia\",\"identifier\":61,\"categories\":[\"SERV ENDOSCOPIA PER-ORAL\"],\"children\":[]},{\"title\":\"Medicina Hiperbárica\",\"identifier\":69,\"categories\":[\"S.OXIGENOTERAP.HIPERBARIC\"],\"children\":[]},{\"title\":\"Medicina Nuclear\",\"identifier\":68,\"categories\":[\"SERV MEDICINA NUCLEAR\"],\"children\":[]},{\"title\":\"Oncologia / Cancerologia\",\"identifier\":126,\"categories\":[],\"children\":[{\"title\":\"Oncologia / Cancerologia\",\"identifier\":127,\"categories\":[\"CANCEROLOGIA/ONCOLOGIA\",\"SERV DE ONCOLOGIA\"],\"children\":[]},{\"title\":\"Pediátrica\",\"identifier\":128,\"categories\":[\"ONCOLOGIA  PEDIATRICA\"],\"children\":[]}]},{\"title\":\"Radiologia\",\"identifier\":72,\"categories\":[\"SERV DE RADIOLOGIA\"],\"children\":[]},{\"title\":\"Radioterapia\",\"identifier\":73,\"categories\":[\"SERV DE RADIOTERAPIA\"],\"children\":[]},{\"title\":\"Ressonância Magnética\",\"identifier\":74,\"categories\":[\"SERV RESSONANCIA MAGNETIC\"],\"children\":[]},{\"title\":\"S.Oxigenoterap.Hiperbaric\",\"identifier\":134,\"categories\":[\"S.OXIGENOTERAP.HIPERBARIC\"],\"children\":[]},{\"title\":\"Tomografia\",\"identifier\":75,\"categories\":[\"SERV DE TOMOGRAFIA\"],\"children\":[]},{\"title\":\"Ultrassonografia\",\"identifier\":76,\"categories\":[\"SERV DE ULTRASSONOGRAFIA\"],\"children\":[]}]},{\"title\":\"Tratamentos Continuados\",\"identifier\":92,\"categories\":[],\"children\":[{\"title\":\"Clínicas de Reabilitação\",\"identifier\":97,\"categories\":[\"CLIN.MEDIC.FISICA-REABIL.\"],\"children\":[]},{\"title\":\"Fisiatria / Fisioterapia\",\"identifier\":94,\"categories\":[\"FISIOTERAPIA\",\"MEDICINA FISICA E REABILI\",\"SERVICO DE FISIOTERAPIA\"],\"children\":[]},{\"title\":\"Fonoaudiologia\",\"identifier\":93,\"categories\":[\"FONOAUDIOLOGIA\",\"SERVICO DE FONOAUDIOLOGIA\"],\"children\":[]},{\"title\":\"Psicoterapia\",\"identifier\":96,\"categories\":[\"PSICOTERAPIA\"],\"children\":[]},{\"title\":\"Terapia Ocupacional\",\"identifier\":95,\"categories\":[\"SERV TERAPIA OCUPACIONAL\",\"TERAPIA OCUPACIONAL\"],\"children\":[]}]}]}" ;
    NSDictionary* dicRoot = (NSDictionary*)[especialidades JSONValue];
    NSLog(@"%@", [dicRoot allKeys]) ;
    
    return _rootEspecialidade = [self fillEspecialidadeFromDictionary:dicRoot];
}

+ (BuscaASMEspecialidade*) fillEspecialidadeFromDictionary:(NSDictionary*) dicEspecialidade
{
    int identifier = [(NSNumber*) [dicEspecialidade objectForKey:@"identifier"] intValue];
    NSString *name = [dicEspecialidade objectForKey:@"title"];
    BuscaASMEspecialidade* especialidade = [[BuscaASMEspecialidade alloc] initWith:identifier andName:name] ;
    
    [especialidade addCategories:(NSArray*) [dicEspecialidade objectForKey:@"categories"]] ;
    
    NSArray *children = (NSArray*) [dicEspecialidade objectForKey:@"children"];
    for (NSDictionary* dicChild in children) {
        BuscaASMEspecialidade *child = [self fillEspecialidadeFromDictionary:dicChild];
        [especialidade addChildren:child];
    }
    
    return especialidade ;
}

@end
