//
//  BuscaASMBoxesView.m
//  BuscaASM
//
//  Created by Bruno on 18/07/12.
//
//

#import "BuscaASMBoxesView.h"
#import <Box2D/Box2D.h>

#define SQUARE_SIZE 14
#define SQUARE_BORDER 4
#define SQUARE_DISTANCE 5
#define SQUARE_FILL_RATE    50  // Entre 0 e 100

#define PTM_RATIO 16

@interface BuscaASMBox : NSObject

@property (nonatomic) CGPoint coordinates ;
@property (nonatomic) CGPoint originalCoordinates ;
@property (nonatomic) CGFloat side ;
@property (nonatomic) CGColorRef color ;
@property (nonatomic) double rotate ; // in radians
@property (nonatomic) b2Body *body ;

@end

@implementation BuscaASMBox

@synthesize coordinates = _coordinates ;
@synthesize originalCoordinates = _originalCoordinates ;
@synthesize side = _side ;
@synthesize color = _color ;
@synthesize rotate = _rotate ;
@synthesize body = _body ;

@end

@interface BuscaASMBoxesView() {
    b2World* world;
}

@property (nonatomic, strong) NSArray * colors ;
@property (nonatomic, strong) NSMutableArray *boxes ;
@property (nonatomic) NSTimer *tickTimer;
@property (nonatomic) BOOL reset ;


@end


@implementation BuscaASMBoxesView

@synthesize colors = _colors;
@synthesize boxes = _boxes ;
@synthesize tickTimer = _tickTimer ;
@synthesize active = _active ;
@synthesize reset = _reset ;

- (NSArray *)colors
{
    if ( ! _colors ) {
        _colors = [[NSArray alloc] initWithObjects:
                   [UIColor colorWithRed:93/(CGFloat)255  green:178/(CGFloat)255 blue:149/(CGFloat)255 alpha:1],
                   [UIColor colorWithRed:85/(CGFloat)255  green:194/(CGFloat)255 blue:152/(CGFloat)255 alpha:1],
                   [UIColor colorWithRed:0/(CGFloat)255   green:147/(CGFloat)255 blue:104/(CGFloat)255 alpha:1],
                   [UIColor colorWithRed:121/(CGFloat)255 green:177/(CGFloat)255 blue:105/(CGFloat)255 alpha:1],
                   nil] ;
    }
    
    return _colors ;
}

- (NSMutableArray *)boxes
{
    if ( !_boxes ) _boxes = [[NSMutableArray alloc] init];
    return _boxes ;
}

- (CGFloat) generateRandomPositionFromSide:(CGFloat) side
{
    int position = arc4random() % (int)(side-SQUARE_SIZE) ;
    return position - position % (SQUARE_DISTANCE+SQUARE_SIZE) ;
}

-(void) setup
{
    [self createPhysicsWorld];
    
    for( int x=0; x<self.bounds.size.width-SQUARE_SIZE; x += SQUARE_SIZE+SQUARE_BORDER) {
        for( int y=0; y<self.bounds.size.height-SQUARE_SIZE; y += SQUARE_SIZE+SQUARE_BORDER) {
            if ( arc4random()%100 < SQUARE_FILL_RATE ) {
                BuscaASMBox *box = [[BuscaASMBox alloc] init] ;
                box.coordinates = CGPointMake(x, y ) ;
                box.originalCoordinates = box.coordinates ;
                box.side = SQUARE_SIZE ;
                box.rotate = 0 ; //2 * M_PI * (arc4random() % 360) / 360  ;
                box.color = [[self.colors objectAtIndex:(arc4random() % self.colors.count)] CGColor] ;
                [self.boxes addObject:box];
                [self addPhysicalBodyForBox:box] ;
            }
        }
    }
    
//    self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

-(void)createPhysicsWorld
{
	CGSize screenSize = self.bounds.size;
    
	// Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, -9.81f);
    
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
//	bool doSleep = true;
    
	// Construct a world object, which will hold and simulate the rigid bodies.
	world = new b2World(gravity);
    world->SetAllowSleeping(false) ;
    
	world->SetContinuousPhysics(true);
    
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
    
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
	// Define the ground box shape.
	b2EdgeShape groundBox;
    
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 0);
    
	// top
	groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox, 0);
    
	// left
	groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox, 0);
    
	// right
	groundBox.Set(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 0);
}

-(void)addPhysicalBodyForBox:(BuscaASMBox *)box
{
	// Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	CGPoint p = CGPointMake(box.coordinates.x + box.side/2, box.coordinates.y + box.side/2);
	CGPoint boxDimensions = CGPointMake(box.side/PTM_RATIO/2.0,box.side/PTM_RATIO/2.0);
    
	bodyDef.position.Set(p.x/PTM_RATIO, (self.bounds.size.height - p.y)/PTM_RATIO);
	bodyDef.userData = (__bridge void*)box;
    
	// Tell the physics world to create the body
	b2Body *body = world->CreateBody(&bodyDef);
    
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
    
	dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = 3.0f;
	fixtureDef.friction = 0.3f;
	fixtureDef.restitution = 0.5f; // 0 is a lead ball, 1 is a super bouncy ball
	body->CreateFixture(&fixtureDef);
    
	// a dynamic body reacts to forces right away
	body->SetType(b2_dynamicBody);
    
	// we abuse the tag property as pointer to the physical body
	box.body = body;
}

-(void) tick:(NSTimer *)timer
{
    if ( self.reset )
        [self resetWorld];
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
    
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(1.0f/60.0f, velocityIterations, positionIterations);
    
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL)
		{
			BuscaASMBox *box = (__bridge BuscaASMBox *)b->GetUserData();
            
			// y Position subtracted because of flipped coordinate system
			CGPoint newCenter = CGPointMake(b->GetPosition().x * PTM_RATIO,
                                            self.bounds.size.height - b->GetPosition().y * PTM_RATIO);
			box.coordinates = CGPointMake(newCenter.x - box.side/2, newCenter.y - box.side/2) ;
            box.rotate = - b->GetAngle() ;
//			CGAffineTransform transform = CGAffineTransformMakeRotation(- b->GetAngle());
//            
//			oneView.transform = transform;
		}
	}
    [self setNeedsDisplay] ;
}

- (void)dealloc
{
    [self.tickTimer invalidate] ;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup] ;
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setup] ;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup] ;
    }
    
    return self;
}

- (void) drawBuscaASMBox:(BuscaASMBox*) box inContext:(CGContextRef) context
{
//    CGAffineTransform matrixBefore = CGContextGetCTM(context) ;
    UIGraphicsPushContext(context) ;
    
    CGContextSetFillColorWithColor(context, box.color) ;
    
    // Rotate context
    CGContextTranslateCTM( context, box.coordinates.x + SQUARE_SIZE/2, box.coordinates.y + SQUARE_SIZE/2 ) ;
    CGContextRotateCTM( context, box.rotate ) ;
    
    // Draw rounded rect
    [self drawRoundedRect:CGRectMake(-SQUARE_SIZE/2, -SQUARE_SIZE/2, box.side, box.side) withRadius:SQUARE_BORDER inContext:context] ;
    
    // Restore rotatation/translation
    CGContextRotateCTM( context, -box.rotate ) ;
    CGContextTranslateCTM( context, -box.coordinates.x - SQUARE_SIZE/2, -box.coordinates.y - SQUARE_SIZE/2 ) ;
    
    UIGraphicsPopContext() ;
}

- (void) drawRoundedRect:(CGRect)rect withRadius:(double)radius inContext:(CGContextRef)context
{
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI / 2, 1); //STS fixed
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI / 2, M_PI, 1);
    CGContextClosePath(context) ;
    
    CGContextDrawPath(context, kCGPathFill);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (BuscaASMBox *box in self.boxes) {
        [self drawBuscaASMBox:box inContext:context];
    }
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if ( ! self.reset ) {
        b2Vec2 gravity;
        gravity.Set( acceleration.x * 9.81,  acceleration.y * 9.81 );
        world->SetGravity(gravity);
    }
}

#define SIGN(x) ((x)<0?-1:1)
#define MAX_FORCE   200

- (void) resetWorld
{
    for (BuscaASMBox *box in self.boxes) {
        b2Vec2 v = box.body->GetLinearVelocity() ;
        CGPoint p = CGPointMake((box.coordinates.x-box.originalCoordinates.x)/PTM_RATIO, (box.coordinates.y-box.originalCoordinates.y)/PTM_RATIO);
        if ( ABS(p.y*PTM_RATIO) < 1 ) {
            // Chegou ao destino
            box.body->m_force.y = 0 ;
            box.body->SetLinearVelocity(b2Vec2(v.x, 0));
            v.y = 0 ;
        } else {
            if ( SIGN(v.y) == SIGN(box.body->m_force.y) ) {
                // Aplicando força de aceleração
                float32 reverseForce = -v.y*v.y/(2*p.y)*box.body->GetMass() ;
                if ( ABS(reverseForce) > MAX_FORCE ) {
                    // Inverte a força
                    box.body->m_force.y = reverseForce ;
                } else {
                    box.body->m_force.y = -SIGN(reverseForce)*MAX_FORCE/2 ;
                }
            }
        }
        
        if ( ABS(p.x*PTM_RATIO) < 1 ) {
            // Chegou ao destino
            box.body->m_force.x = 0 ;
            box.body->SetLinearVelocity(b2Vec2(0, v.y));
            v.x = 0 ;
        } else {
            if ( SIGN(v.x) == SIGN(box.body->m_force.x) ) {
                // Aplicando força de aceleração
                float32 reverseForce = v.x*v.x/(2*p.x)*box.body->GetMass() ;
                if ( ABS(reverseForce) > MAX_FORCE ) {
                    // Inverte a força
                    box.body->m_force.x = reverseForce ;
                } else {
                    box.body->m_force.x = -SIGN(reverseForce)*MAX_FORCE/2 ;
                }
            }
        }

//
//        if (ABS(p.x) < 2) {
//            if ( p.x != 0 )
//                box.body->m_force.x = -v.x*v.x/(2*p.x)*box.body->GetMass();
//        } else if ( v.x*p.x > 0 && ABS(p.x) < 4 ) {
//            box.body->m_force.x = 0 ;
//        } else {
//            box.body->m_force.x = -p.x ;
//        }
//        if (ABS(p.y) < 2 && v.y*p.y < -2) {
//            if ( p.y != 0 )
//                box.body->m_force.y = v.y*v.y/(2*p.y)*box.body->GetMass();
//        } else if ( v.y*p.y < -2 && ABS(p.y) < 4 ) {
//            box.body->m_force.y = 0 ;
//        } else {
//            box.body->m_force.y = p.y ;
//        }
//        NSLog(@"fy=%2.4f / p.y=%2.4f",box.body->m_force.y, p.y);
//        box.body->ApplyForceToCenter(b2Vec2(10*-p.x, 10*p.y)) ;
    }
}

- (void)setActive:(BOOL)active
{
    NSLog(@"active = %d", active);
    if ( active ) {
        [self.tickTimer invalidate];
        self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
        self.reset = NO ;
        world->SetGravity(b2Vec2(0, -9.81)) ;
    } else {
        world->SetGravity(b2Vec2(0, 0)) ;
        [self resetWorld];
        self.reset = YES ;
        UIColor *uiColor = [self.colors objectAtIndex:1] ;
        CGColorRef color = CGColorCreateCopyWithAlpha(uiColor CGColor, 0.5) ;
        
    }
    _active = active ;
}

@end