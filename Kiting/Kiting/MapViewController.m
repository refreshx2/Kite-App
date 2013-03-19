//
//  MapViewController.m
//  Kiting
//
//  Created by JASON MALDONIS on 2/18/13.
//  Copyright (c) 2013 JASON MALDONIS. All rights reserved.
//

#import "MapViewController.h"

#import "MapViewAnnotation.h"

#import "SpotListDataController.h"

#import "KiteSpotAppDelegate.h"

#import "AddLocationViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;

- (void)awakeFromNib
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //NSLog(@"In MapVC's viewDidLoad");
    [super viewDidLoad];
    
    mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.mapType = MKMapTypeHybrid;
    [self.view addSubview:mapView];
    self.mapView.showsUserLocation = YES;
    
    self.dataController = ((KiteSpotAppDelegate *) [[UIApplication sharedApplication] delegate]).dataController;

    //Beloit Lat: 42.507793
    //Beloit Long: -89.033031
    //Coe Lat: 37.909534
    //Coe Long: -122.579956
    [mapView setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"In viewDidAppear");
    //Remove all annotation on the map previously
    NSMutableArray * annotationsToRemove = [self.mapView.annotations mutableCopy] ;
    [annotationsToRemove removeObject:mapView.userLocation] ;
    [self.mapView removeAnnotations:annotationsToRemove] ;
    
    //Add all the spots in the list
    ASpot *aSpot;
    MapViewAnnotation *newAnnotation;
    CLLocationCoordinate2D loc;
    for (NSInteger i = 0; i < [self.dataController countOfList]; i++) {
        aSpot = [self.dataController.masterList objectAtIndex:i];
        loc.latitude = (double) [aSpot.latitude doubleValue];
        loc.longitude = (double) [aSpot.longitude doubleValue];
        newAnnotation = [[MapViewAnnotation alloc] initWithTitle:[NSString stringWithFormat:@"%@", aSpot.siteName] andCoordinate:loc andSpot:aSpot];
        
        [self.mapView addAnnotation:newAnnotation];
    }

    //Set zoom level and initial map position to user location
    CLLocationCoordinate2D coord;
    coord.latitude = self.mapView.userLocation.location.coordinate.latitude;
    coord.longitude = self.mapView.userLocation.location.coordinate.longitude;
    NSLog(@"user loc = (%f,%f)",coord.latitude,coord.longitude);
    MKCoordinateSpan span = {.latitudeDelta =  0.3, .longitudeDelta =  0.3};
    MKCoordinateRegion region = {coord, span};
    [mapView setRegion:region animated:TRUE];
    
    //Set long press gesture
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.view addGestureRecognizer:longPress];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Add a new spot here?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add!",nil];
        CGPoint touchLocation = [gesture locationInView:mapView];
        touchCoordinate = [self.mapView convertPoint:touchLocation toCoordinateFromView:self.mapView];
        [action showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSegueWithIdentifier: @"goToDetailsFromMap" sender: self];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%@ pin selected.",view.annotation.title);
    
    //One problem is that this could take a while to search the entire array...
    ASpot * aSpot;
    for(NSInteger i = 0; i < [self.dataController countOfList]; i++) {
        aSpot = [self.dataController objectInListAtIndex:i];
        if( ([aSpot.longitude doubleValue] == view.annotation.coordinate.longitude) && ([aSpot.latitude doubleValue] == view.annotation.coordinate.latitude) ) {
            
            NSString *message = [NSString stringWithFormat:@"City: %@\nState: %@\nDays: %@\nTimes: %@\nWind: %@\nEmail: %@\nPhone: %@",aSpot.city,aSpot.state,aSpot.days,aSpot.times,aSpot.wind,aSpot.email,aSpot.phone];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aSpot.siteName message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            break;
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%@ pin deselected.",view.annotation.title);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToDetailsFromMap"]) {
        //Pass location data
        AddLocationViewController *addLVC = (AddLocationViewController*) [(UINavigationController*) [segue destinationViewController] topViewController];
        [addLVC view]; //Force the view to load so I can edit the labels: http://stackoverflow.com/questions/2720662/uilabel-not-updating
        NSString *str1 = [NSString stringWithFormat:@"%f",touchCoordinate.latitude];
        NSString *str2 = [NSString stringWithFormat:@"%f",touchCoordinate.longitude];
        [addLVC.latitudeInput setText:str1];
        [addLVC.longitudeInput setText:str2];
    }
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    //NSLog(@"In MVC's cance:");
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
