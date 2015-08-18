//
//  PictureDataTransformer.m
//  Thousand Words
//
//  Created by OSX on 8/18/15.
//  Copyright (c) 2015 LebonTech Solutions. All rights reserved.
//

#import "PictureDataTransformer.h"
#import <UIKit/UIKit.h>

@implementation PictureDataTransformer

// method to return what kind of class we want the image to be turned into
+(Class)transformedValueClass
{
    return [NSData class];
}

// Method to all the data to be turned back into image
+(BOOL)allowsReverseTransformation
{
    return YES;
}

// Method to transform a UIImage to data
-(id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value); //.. returns data representation of UIImage
}

// method to return a UIIMage from the core data data
-(id)reverseTransformedValue:(id)value
{
    UIImage *image = [UIImage imageWithData:value]; //.. returns a UIImage from the data
    return image;
}

@end
