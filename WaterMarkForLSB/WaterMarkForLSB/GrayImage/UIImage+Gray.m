//
//  UIImage+Gray.m
//  WaterMarkForLSB
//
//  Created by zz go on 2021/2/4.
//

#import "UIImage+Gray.h"

@implementation UIImage (Gray)

/**
 二值化
 */
- (UIImage *)covertToBinaryzation:(float)scale
{
    //系数范围 0-1.参数保护
    scale = MAX(0, scale);
    scale = MIN(1.0, scale);
    
    CGSize size =[self size];
    int width =size.width;
    int height =size.height;
    
    //像素将画在这个数组
    uint32_t *pixels = (uint32_t *)malloc(width *height *sizeof(uint32_t));
    //清空像素数组
    memset(pixels, 0, width*height*sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //用 pixels 创建一个 context
    CGContextRef context =CGBitmapContextCreate(pixels, width, height, 8, width*sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    int RED =1;
    int GREEN =2;
    int BLUE =3;
    CGFloat intensity;
    int bw;
    int gray = 0;
    
    for (int y = 0; y <height; y++) {
        for (int x =0; x <width; x ++) {
            uint8_t *rgbaPixel = (uint8_t *)&pixels[y*width+x];
            //灰度值计算，使用加权平均数方法
            gray  =  rgbaPixel[RED] *0.3  + rgbaPixel[GREEN] * 0.59 + rgbaPixel[BLUE] * 0.11;
            intensity = (CGFloat)( gray / 255.);
            //决定取黑或白
            bw = intensity > scale ? 255:0;
            
            rgbaPixel[RED] = bw;
            rgbaPixel[GREEN] = bw;
            rgbaPixel[BLUE] = bw;
            
        }
    }

    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

+ (UIImage *)grayForImage:(UIImage*)image forType:(GrayImageType)type
{
    // Adapted from this thread: http://stackoverflow.com/questions/1298867/convert-image-to-grayscale
    const int RED =1;
    const int GREEN =2;
    const int BLUE =3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0,0, image.size.width* image.scale, image.size.height* image.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t*) malloc(width * height *sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels,0, width * height *sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,8, width *sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context,CGRectMake(0,0, width, height), [image CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t*) &pixels[y * width + x];
            
            uint32_t gray = 0;
            switch (type) {
                case GrayImageTypeWeightedAverage:
                    // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
                     gray = 0.3 * rgbaPixel[RED] +0.59 * rgbaPixel[GREEN] +0.11 * rgbaPixel[BLUE];
                    break;
                case GrayImageTypeAverage:
                     gray = ( rgbaPixel[RED] + rgbaPixel[GREEN] + rgbaPixel[BLUE])/3;
                    break;
                case GrayImageTypeMax:
                     gray = MAX( MAX(rgbaPixel[RED],rgbaPixel[GREEN]) , rgbaPixel[BLUE]);
                    break;
                case GrayImageTypeRed:
                     gray = rgbaPixel[RED] ;
                    break;
                case GrayImageTypeGreen:
                     gray = rgbaPixel[GREEN] ;
                    break;
                case GrayImageTypeBlue:
                     gray = rgbaPixel[BLUE] ;
                    break;
                default:
                    break;
            }
            
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(imageRef);
    
    return resultUIImage;
}

@end


