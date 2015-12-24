//
//  CTEditView.m
//  Pods
//
//  Created by 黄成 on 15/12/22.
//
//

#import "CTEditView.h"
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Configuration.h"
#import "UIImage+TintColor.h"
#import "UIView+CTBoundsWithImage.h"

@interface CTEditView (){
    CGPoint _lasPoint;
}

@property (nonatomic,strong) UIImageView *viewImage;
@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) NSMutableArray *layerArray;

@property (nonatomic,strong) NSMutableArray *nowLayerArray;
@property (nonatomic,strong) NSMutableArray *removeLayerArray;

@end

@implementation CTEditView

- (instancetype)initWithImage:(UIImage*)image withFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        self.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.viewImage];
        self.clipsToBounds = YES;
        
        CGRect viewFrame = self.frame;
        CGRect nowFrame = [self getBoundsWithImage:self.image];
        viewFrame.size.height = nowFrame.size.height;
        viewFrame.size.width = nowFrame.size.width;
        self.frame = viewFrame;
        [self setCanEdit:NO];
    }
    return self;
}
- (void)packageWithImage:(UIImage*)image{
    if (image) {
        self.viewImage.image = image;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    CGPoint p = [[touches anyObject] locationInView:self];
    _lasPoint = p;
    self.nowLayerArray  = [[NSMutableArray alloc]init];
    [self.removeLayerArray removeAllObjects];
    [self.nowLayerArray removeAllObjects];
    [self drawMasoic:p];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    CGPoint p = [[touches anyObject] locationInView:self];
    _lasPoint = p;
    
    [self drawMasoic:p];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.layerArray addObject:self.nowLayerArray];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesCancelled:touches withEvent:event];
    [self.layerArray addObject:self.nowLayerArray];
}
- (void)drawMasoic:(CGPoint)point{
    
    
    CGRect rect = CGRectMake(point.x-10, point.y-10, 20, 20);
    
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    self.viewImage.backgroundColor = color;
    
    
    CALayer *layer = [[CALayer alloc]init];
    layer.frame = rect;
    layer.contents = (id)[[UIImage imageNamed:CTCameraImage(@"ct_camera_masico_icon")] tintImageWithColor:color].CGImage;
    [self.layer addSublayer:layer];
    
    [self.nowLayerArray addObject:layer];

}

-(UIImage*)convertViewToImage:(CGRect)rect{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef nowImageRef = image.CGImage;
    CGImageRef newImageRef = CGImageCreateWithImageInRect(nowImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    return newImage;
}

#pragma mark class 


- (BOOL)hasNextStep{//是否有下一步
    if (self.removeLayerArray && [self.removeLayerArray count] >= 1) {
        return YES;
    }
    return NO;
    
}
- (void)nextStep{//下一步
    NSMutableArray *array = [self.removeLayerArray lastObject];
    for (CALayer *layer in array ) {
        [self.layer addSublayer:layer];
    }
    [self.removeLayerArray removeLastObject];
    [self.layerArray addObject:array];
}

- (BOOL)hasLastStep{//是否有上一步
    if (self.layerArray && [self.layerArray count] >= 1) {
        return YES;
    }
    return NO;
    
}
- (void)lastStep{//上一步
    
    NSMutableArray *array = [self.layerArray lastObject];
    for (CALayer *layer in array ) {
        [layer removeFromSuperlayer];
    }
    [self.layerArray removeLastObject];
    [self.removeLayerArray addObject:array];
}

- (void)removeAllSubLayerOnView{
    for (NSMutableArray *array in self.layerArray) {
        for (CALayer *layer in array) {
            [layer removeFromSuperlayer];
        }
    }
}

- (UIImage*)getFinalImage{
    
    [self.nowLayerArray removeAllObjects];
    [self.layerArray removeAllObjects];
    [self.removeLayerArray removeAllObjects];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setCanEdit:(BOOL)canEdit{
    self.userInteractionEnabled = canEdit;
}
#pragma mark GETTER AND SETTER

- (UIImageView *)viewImage{
    if (!_viewImage) {
        _viewImage = [[UIImageView alloc]init];
    }
    return _viewImage;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self.image drawInRect:rect];
 }

- (NSMutableArray *)layerArray{
    if (!_layerArray) {
        _layerArray = [[NSMutableArray alloc]init];
    }
    return _layerArray;
}

- (NSMutableArray *)removeLayerArray{
    if (!_removeLayerArray) {
        _removeLayerArray = [[NSMutableArray alloc]init];
    }
    return _removeLayerArray;
}
@end
