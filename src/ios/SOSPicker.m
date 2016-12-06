//
//  SOSPicker.m
//  SyncOnSet
//
//  Created by Christopher Sullivan on 10/25/13.
//
//

#import "SOSPicker.h"
#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"

#define CDV_PHOTO_PREFIX @"cdv_photo_"

@implementation SOSPicker

@synthesize callbackId;

- (void) getPictures:(CDVInvokedUrlCommand *)command {
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    
    NSInteger maximumImagesCount = [[options objectForKey:@"maximumImagesCount"] integerValue];
    self.width = [[options objectForKey:@"width"] integerValue];
    self.height = [[options objectForKey:@"height"] integerValue];
    self.quality = [[options objectForKey:@"quality"] integerValue];
    self.square = [[options objectForKey:@"square"] integerValue];
    
    // Create the an album controller and image picker
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithLoadingTitle: [options objectForKey:@"loading_name"]];
    albumController.okBtnText = [options objectForKey:@"ok"];
    albumController.cancelBtnText = [options objectForKey:@"discard"];
    albumController.errorDesc = [options objectForKey:@"error_database"];
    albumController.multychooserName = [options objectForKey:@"multy_chooser_name"];
    albumController.singlechooserName = [options objectForKey:@"single_chooser_name"];
    albumController.loadingName = [options objectForKey:@"loading_name"];
    albumController.maximumSelectionErrorHeader = [options objectForKey:@"maximum_selection_count_error_header"];
    albumController.maximumSelectionErrorMsg = [options objectForKey:@"maximum_selection_count_error_message"];
    if (maximumImagesCount == 1) {
        albumController.immediateReturn = true;
        albumController.singleSelection = true;
    } else {
        albumController.immediateReturn = false;
        albumController.singleSelection = false;
    }
    
    ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    imagePicker.loadingName = albumController.loadingName;
    imagePicker.okBtnText = albumController.okBtnText;
    imagePicker.cancelBtnText = albumController.cancelBtnText;
    imagePicker.errorDesc = albumController.errorDesc;
    imagePicker.multychooserName = albumController.multychooserName;
    imagePicker.singlechooserName =albumController.singlechooserName;
    imagePicker.maximumSelectionErrorHeader = albumController.maximumSelectionErrorHeader;
    imagePicker.maximumSelectionErrorMsg = albumController.maximumSelectionErrorMsg;
    
    imagePicker.maximumImagesCount = maximumImagesCount;
    imagePicker.returnsOriginalImage = NO;//To ignore the original orientation-- 20161111 janus
    imagePicker.imagePickerDelegate = self;
    
    albumController.parent = imagePicker;
    self.callbackId = command.callbackId;
    // Present modally
    [self.viewController presentViewController:imagePicker
                                      animated:YES
                                    completion:nil];
}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    CDVPluginResult* result = nil;
    NSMutableArray *resultStrings = [[NSMutableArray alloc] init];
    NSData* data = nil;
    NSString* docsPath = [NSTemporaryDirectory()stringByStandardizingPath];
    NSError* err = nil;
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    NSString* filePath;
    ALAsset* asset = nil;
    UIImageOrientation orientation = UIImageOrientationUp;;
    CGSize targetSize = CGSizeMake(self.width, self.height);
    for (NSDictionary *dict in info) {
        asset = [dict objectForKey:@"ALAsset"];
        // From ELCImagePickerController.m
        
        int i = 1;
        do {
            filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_PHOTO_PREFIX, i++, @"jpg"];
        } while ([fileMgr fileExistsAtPath:filePath]);
        
        @autoreleasepool {
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            CGImageRef imgRef = NULL;
            
            //defaultRepresentation returns image as it appears in photo picker, rotated and sized,
            //so use UIImageOrientationUp when creating our image below.
            if (picker.returnsOriginalImage) {
                imgRef = [assetRep fullResolutionImage];
                orientation = [assetRep orientation];
            } else {
                imgRef = [assetRep fullScreenImage];
            }
            
            UIImage* image = [UIImage imageWithCGImage:imgRef scale:1.0f orientation:orientation];
            if(self.square != 0){
                image = [self toSquareImage:image];
            }
            if (self.width == 0 && self.height == 0) {
                data = UIImageJPEGRepresentation(image, self.quality/100.0f);
            } else {
                UIImage* scaledImage = [self imageByScalingNotCroppingForSize:image toSize:targetSize];
                data = UIImageJPEGRepresentation(scaledImage, self.quality/100.0f);
            }
            
            if (![data writeToFile:filePath options:NSAtomicWrite error:&err]) {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[err localizedDescription]];
                break;
            } else {
                [resultStrings addObject:[[NSURL fileURLWithPath:filePath] absoluteString]];
            }
        }
        
    }
    
    if (nil == result) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultStrings];
    }
    
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    CDVPluginResult* pluginResult = nil;
    NSArray* emptyArray = [NSArray array];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:emptyArray];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (UIImage*)imageByScalingNotCroppingForSize:(UIImage*)anImage toSize:(CGSize)frameSize
{
    UIImage* sourceImage = anImage;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = frameSize.width;
    CGFloat targetHeight = frameSize.height;
    CGFloat scaleFactor = 0.0;
    CGSize scaledSize = frameSize;
    
    if (CGSizeEqualToSize(imageSize, frameSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        // opposite comparison to imageByScalingAndCroppingForSize in order to contain the image within the given bounds
        if (widthFactor == 0.0) {
            scaleFactor = heightFactor;
        } else if (heightFactor == 0.0) {
            scaleFactor = widthFactor;
        } else if (widthFactor > heightFactor) {
            scaleFactor = heightFactor; // scale to fit height
        } else {
            scaleFactor = widthFactor; // scale to fit width
        }
        scaledSize = CGSizeMake(width * scaleFactor, height * scaleFactor);
    }
    
    UIGraphicsBeginImageContext(scaledSize); // this will resize
    
    [sourceImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*) toSquareImage:(UIImage*) anImage
{
    NSLog(@"come scale image");
    
    UIImage* sourceImage = anImage;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    NSLog(@"width %f",width);
    NSLog(@"height %f",height);
    CGFloat targetWidth = 0.0;
    CGFloat targetHeight = 0.0;
    if(width>height){
        targetWidth = width;
        targetHeight = width;
        CGSize scaledSize = CGSizeMake(targetWidth, targetHeight);
        UIGraphicsBeginImageContext(scaledSize); // this will resize
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIColor *bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        CGContextSetStrokeColorWithColor(ctx, bgColor.CGColor);
        CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
        CGRect bgRect = CGRectMake(0, 0, targetWidth,targetHeight);
        CGContextAddRect(ctx, bgRect);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        [sourceImage drawInRect:CGRectMake(0, (width-height)/2, imageSize.width, imageSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if (newImage == nil) {
            NSLog(@"could not scale image");
        }
        
        // pop the context to get back to the default
        UIGraphicsEndImageContext();
        return newImage;
        
    }else{
        targetWidth = height;
        targetHeight = height;
        CGSize scaledSize = CGSizeMake(targetWidth, targetHeight);
        UIGraphicsBeginImageContext(scaledSize); // this will resize
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIColor *bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        CGContextSetStrokeColorWithColor(ctx, bgColor.CGColor);
        CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
        CGRect bgRect = CGRectMake(0, 0, targetWidth,targetHeight);
        CGContextAddRect(ctx, bgRect);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        [sourceImage drawInRect:CGRectMake((height-width)/2, 0, imageSize.width, imageSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if (newImage == nil) {
            NSLog(@"could not scale image");
        }
        
        // pop the context to get back to the default
        UIGraphicsEndImageContext();
        return newImage;
        
    }
}

@end
