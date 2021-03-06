//
//  AIViewController.m
//  iMapToy
//
//  Created by Asim Ihsan on 04/08/2013.
//  Copyright (c) 2013 Asim Ihsan. All rights reserved.
//

#import "AIViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <TSMessage.h>
#import <BlockActionSheet.h>
#import <ConciseKit.h>

@interface AIViewController ()

- (void)addMarker:(CLLocationCoordinate2D)coordinate
      isAvailable:(BOOL)isAvailable;

@end

@implementation AIViewController

GMSMapView *mapView;
UIImage *flagRed;
UIImage *flagGreen;

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    flagRed = [UIImage imageNamed:@"flag_red"];
    flagGreen = [UIImage imageNamed:@"flag_green"];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.26123
                                                            longitude:-123.11393
                                                                 zoom:14];
    mapView = [GMSMapView mapWithFrame:CGRectZero
                                camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.indoorEnabled = NO;
    mapView.delegate = self;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    self.view = mapView;
    
    [self addMarker:CLLocationCoordinate2DMake(49.26123, -123.11393)
        isAvailable:YES];
    [self addMarker:CLLocationCoordinate2DMake(49.25705, -123.11616)
        isAvailable:NO];
}

#pragma mark - Private methods

- (void)addMarker:(CLLocationCoordinate2D)coordinate
      isAvailable:(BOOL)isAvailable {
    GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
    marker.title = @"Residential";
    marker.icon = isAvailable ? flagGreen : flagRed;
    marker.map = mapView;
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSString *message = [NSString stringWithFormat:@"At %f,%f",
                         coordinate.latitude,
                         coordinate.longitude];
    [TSMessage showNotificationInViewController:self
                                      withTitle:@"Added a spot"
                                    withMessage:message
                                       withType:TSMessageNotificationTypeSuccess
                                   withDuration:2.0];
    [self addMarker:coordinate
        isAvailable:NO];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"Adjust parking spot"];
    [sheet setCancelButtonWithTitle:@"Cancel" block:nil];
    [sheet setDestructiveButtonWithTitle:@"Delete" block:^{
        marker.map = nil;
    }];
    [sheet addButtonWithTitle:@"Toggle free status"
                      atIndex:0
                        block:^{
                            marker.icon = $eql(marker.icon, flagRed) ?
                                flagGreen : flagRed;
    }];
    [sheet showInView:self.view];
    return YES;
}

/* The UIViews returned by markerInfoWindow are rendered into flat images,
 so they cannot be used for interactivity.
 
 Reference: http://stackoverflow.com/questions/15213049/add-buttons-to-view-returned-by-markerinfowindow-delegate-method
 - (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {};
*/

@end
