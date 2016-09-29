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
@property (copy) NSString *okBtnText;
@property (copy) NSString *cancelBtnText;
@property (copy) NSString *errorDesc;
@property (copy) NSString *multychooserName;
@property (copy) NSString *singlechooserName;
@property (copy) NSString *loadingName;
@property (copy) NSString *maximumSelectionErrorHeader;
@property (copy) NSString *maximumSelectionErrorMsg;

// optional, can be used to filter the assets displayed
@property (nonatomic, weak) id<ELCAssetPickerFilterDelegate> assetPickerFilterDelegate;
- (id)initWithLoadingTitle:(NSString *)loadingTitle;
@end

