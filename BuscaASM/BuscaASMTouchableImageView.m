//
//  BuscaASMTouchableImageView.m
//  BuscaASM
//
//  Created by Bruno on 18/07/12.
//
//

#import "BuscaASMTouchableImageView.h"

@interface BuscaASMTouchableImageView()

@property (nonatomic) NSTimer *timer;

@end

@implementation BuscaASMTouchableImageView

@synthesize timer = _timer ;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( touches.count == 1 ) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO]; ;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.timer invalidate] ;
    self.timer = nil ;
}

-(void) onTimer:(NSTimer *)timer
{
    [self.delegateLongTouch onLongTouchImage:self];
    [self.timer invalidate] ;
    self.timer = nil ;
}

@end
