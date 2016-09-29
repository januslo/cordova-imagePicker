//
//  AlbumPickerController.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAssetSelectionDelegate.h"
#import "ELCAssetPickerFilterDelegate.h"

@interface ELCAlbumPickerController : UITableViewController <ELCAssetSelectionDelegate>

@property (nonatomic, weak) id<ELCAssetSelectionDelegate> parent;
@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, assign) BOOL singleSelection;
@property (nonatomic, assign) BOOL immediateReturn;
@property (nonatomic, assign) NSString *loadingTitle;
@property (nonatomic, assign) NSString *okBtnText;
@property (nonatomic, assign) NSString *errorDesc;
@property (nonatomic, assign) NSString *chooserName;
@property (nonatomic, assign) NSString *maximumSelectionErrorHeader;
@property (nonatomic, assign) NSString *maximumSelectionErrorMsg;

// optional, can be used to filter the assets displayed
@property (nonatomic, weak) id<ELCAssetPickerFilterDelegate> assetPickerFilterDelegate;

@end

