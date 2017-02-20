//
//  OpenCvFilter.m
//  GekigaCamera
//
//  Created by hirauchi.shinichi on 2017/02/19.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GekigaCamera-Bridging-Header.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation OpenCv : NSObject

- (id) init {
    if (self = [super init]) {
        self.adaptiveThreshold0 = 2;
        self.adaptiveThreshold1 = 2;
    }
    return self;
}

-(UIImage *)Filter:(UIImage *)image {
    
    // 方向を修正
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //UIImageをcv::Matに変換
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::cvtColor(mat,mat,CV_BGR2GRAY);
    
    //Blur ぼかし
    if(_useBlur) {
        // kSizeは奇数のみ
        int kSize = _blur0;
        if(kSize % 2 == 0) {
            kSize += 1;
        }
        cv::GaussianBlur(mat, mat, cv::Size(kSize,kSize), _blur1);
    }
    
    // 閾値
    if(_useTreshold) {
        cv::threshold(mat, mat, 0, 255, cv::THRESH_BINARY|cv::THRESH_OTSU);
    }
    
    // 適応閾値
    if(_useAdaptiveTreshold) {
        
        // blockSizeは奇数のみ
        int blockSize = _adaptiveThreshold0;
        if(blockSize % 2 == 0) {
            blockSize += 1;
        }
        cv::adaptiveThreshold(mat, mat, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY, blockSize, _adaptiveThreshold1);
    }

    return MatToUIImage(mat);
}

@end

