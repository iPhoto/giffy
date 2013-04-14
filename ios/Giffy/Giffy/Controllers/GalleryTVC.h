//
//  GalleryTVC.h
//  Giffy
//
//  Created by Kyle Olivo on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifRepository.h"

@interface GalleryTVC : UITableViewController


@property (nonatomic, strong) GifRepository *repo;
@property (nonatomic, strong) NSArray *gifManagers;

@end
