//
//  AddLocationViewController.h
//  Kiting
//
//  Created by JASON MALDONIS on 2/12/13.
//  Copyright (c) 2013 JASON MALDONIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASpot;
@class SpotListDataController;

@interface AddLocationViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *siteNameInput;
@property (weak, nonatomic) IBOutlet UITextField *cityInput;
@property (weak, nonatomic) IBOutlet UITextField *stateInput;
@property (weak, nonatomic) IBOutlet UITextField *longitudeInput;
@property (weak, nonatomic) IBOutlet UITextField *latitudeInput;
@property (weak, nonatomic) IBOutlet UITextField *daysInput;
@property (weak, nonatomic) IBOutlet UITextField *timesInput;
@property (weak, nonatomic) IBOutlet UITextField *windInput;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *phoneInput;

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@property (strong, nonatomic) ASpot *aSpot;

@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL allowEditing;

@property (strong, nonatomic) SpotListDataController *dataController;

@end
