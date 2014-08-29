//
//  MainViewController.m
//  BluetoothLELocation
//
//  Created by Sanjeeva on 1/31/14.
//  Copyright (c) 2014 Sanjeeva. All rights reserved.
//

#import "MainViewController.h"
#import "CentralViewController.h"
#import "PeripheralViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)CentralTapped:(id)sender {
    CentralViewController *centralViewController = [[CentralViewController alloc]initWithNibName:@"CentralViewController" bundle:nil];
    [self.navigationController pushViewController:centralViewController animated:NO];
    
}
- (IBAction)PeripheralTapped:(id)sender {
    PeripheralViewController *peripheralViewController = [[PeripheralViewController alloc]initWithNibName:@"PeripheralViewController" bundle:nil];
    [self.navigationController pushViewController:peripheralViewController animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
