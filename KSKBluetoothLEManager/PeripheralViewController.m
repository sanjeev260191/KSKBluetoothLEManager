//
//  PeripheralViewController.m
//  BluetoothLE
//
//  Created by Sanjeeva on 1/30/14.
//  Copyright (c) 2014 Sanjeeva. All rights reserved.
//

#import "PeripheralViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface PeripheralViewController ()<CBPeripheralManagerDelegate> {
    CBPeripheralManager *myPeripheralManager;
    CBUUID *myCustomServiceUUID;
    NSData *myValue;
    CBMutableCharacteristic *myCharacteristic;
}
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation PeripheralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Peripheral Manager";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    myPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    myValue = [NSKeyedArchiver archivedDataWithRootObject:@"abcd"];
    self.statusLabel.text = @"Intiating Peripheral Manger to send data containing string -abcd";
    
}
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    [myPeripheralManager updateValue:myValue forCharacteristic:characteristic onSubscribedCentrals:nil];
}
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    if(myPeripheralManager.state==CBPeripheralManagerStatePoweredOn)
    {
        //Now do your scanning and retrievals
        myCustomServiceUUID =  [CBUUID UUIDWithString:@"ECE1A9DC-3027-4871-96E6-9B390A1FB6FA"];
        CBUUID *myCharacteristicUUID =  [CBUUID UUIDWithString:@"F6F49F52-F8EC-4D2F-9AF0-D5B257678923"];
        myCharacteristic = [[CBMutableCharacteristic alloc] initWithType:myCharacteristicUUID
                                                     
                                                                                       properties:CBCharacteristicPropertyNotify | CBCharacteristicPropertyRead
                                                     
                                                                                            value:nil permissions:CBAttributePermissionsReadable];
        CBMutableService *myService = [[CBMutableService alloc] initWithType:myCustomServiceUUID primary:YES];
        myService.characteristics = @[myCharacteristic];
        
        [myPeripheralManager addService:myService];
        
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral

            didAddService:(CBService *)service

                    error:(NSError *)error {
    
    
    
    if (error) {
        self.statusLabel.text = [NSString stringWithFormat:@"Error publishing service: %@", [error localizedDescription]];
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
        
    }else{
        self.statusLabel.text = @"Publishing service";
    }
    [myPeripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey :
                                                 
                                                 @[myCustomServiceUUID] }];
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral

                                       error:(NSError *)error {
    if (error) {
         self.statusLabel.text = [NSString stringWithFormat:@"Error advertising: %@", [error localizedDescription]];
        NSLog(@"Error advertising: %@", [error localizedDescription]);
        
    }else{
        self.statusLabel.text = @"Stated Advertising";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
