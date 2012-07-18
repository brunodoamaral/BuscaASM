//
//  BuscaASMTouchableImageView.h
//  BuscaASM
//
//  Created by Bruno on 18/07/12.
//
//

#import <UIKit/UIKit.h>

@class BuscaASMTouchableImageView ;

@protocol BuscaASMTouchableImageViewTouch

- (void) onLongTouchImage:(BuscaASMTouchableImageView *)image;

@end

@interface BuscaASMTouchableImageView : UIImageView

@property (nonatomic, weak) IBOutlet id<BuscaASMTouchableImageViewTouch> delegateLongTouch ;

@end
