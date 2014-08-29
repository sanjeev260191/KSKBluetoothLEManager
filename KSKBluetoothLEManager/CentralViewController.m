//
//  CentralViewController.m
//  BluetoothLE
//
//  Created by Sanjeeva on 1/30/14.
//  Copyright (c) 2014 Sanjeeva. All rights reserved.
//

#import "CentralViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface CentralViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>{
    
    
    CBCentralManager* myCentralManager;
    CBService *interestingService;
    CBCharacteristic *interestingCharacteristic;
}
@property (strong, nonatomic) CBPeripheral     *connectingPeripheral;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation CentralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Central Manager";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if(central.state==CBCentralManagerStatePoweredOn)
    {
        //Now do your scanning and retrievals
        [myCentralManager scanForPeripheralsWithServices:nil options:nil];
        self.statusLabel.text = @"Scanning";
    }else{
        self.statusLabel.text = @"Please check if Bluetooth is turned on";
    }
}
- (void)centralManager:(CBCentralManager *)central

 didDiscoverPeripheral:(CBPeripheral *)peripheral

     advertisementData:(NSDictionary *)advertisementData

                  RSSI:(NSNumber *)RSSI {
    
    CBUUID *check = [advertisementData valueForKey:CBAdvertisementDataServiceUUIDsKey];
    
    NSLog(@"Discovered %@", check);
    self.statusLabel.text = [NSString stringWithFormat:@"Discovered %@", check];
    
    NSLog(@"Discovered %@", peripheral.name);
    self.statusLabel.text = [NSString stringWithFormat:@"Discovered %@", peripheral.name];
    
//    [myCentralManager stopScan];
//    NSLog(@"Scanning stopped");
    
    self.connectingPeripheral = peripheral;
    [myCentralManager connectPeripheral:self.connectingPeripheral options:nil];
    
}
- (void)centralManager:(CBCentralManager *)central

  didConnectPeripheral:(CBPeripheral *)peripheral {
    
    
    
    NSLog(@"Peripheral connected");
    self.statusLabel.text = [NSString stringWithFormat:@"Peripheral connected"];
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral

didDiscoverServices:(NSError *)error {
    
    
    
    for (CBService *service in peripheral.services) {
        
        NSLog(@"Discovered service %@", service);
        interestingService = service;
        
    }
    NSLog(@"Discovering characteristics for service %@", interestingService);
    self.statusLabel.text = [NSString stringWithFormat:@"Discovering characteristics for service %@", interestingService];
    [peripheral discoverCharacteristics:nil forService:interestingService];
    
}
- (void)peripheral:(CBPeripheral *)peripheral

didDiscoverCharacteristicsForService:(CBService *)service

             error:(NSError *)error {
    
    
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        NSLog(@"Discovered characteristic %@", characteristic);
        interestingCharacteristic = characteristic;
    }
    NSLog(@"Reading value for characteristic %@", interestingCharacteristic);
    self.statusLabel.text = [NSString stringWithFormat:@"Reading value for characteristic %@", interestingCharacteristic];
    [peripheral readValueForCharacteristic:interestingCharacteristic];
    [peripheral setNotifyValue:YES forCharacteristic:interestingCharacteristic];
    
}
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"%hhd",characteristic.isNotifying);
    if (characteristic.isNotifying) {
    
    }
}
- (void)peripheral:(CBPeripheral *)peripheral

didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic

             error:(NSError *)error {
    
    
    
    NSData *data = characteristic.value;
    NSLog(@"%@",data);
    self.statusLabel.text = [NSString stringWithFormat:@"Data received %@", data];
    NSString* newStr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@",newStr);
    self.statusLabel.text = [NSString stringWithFormat:@"String received %@", newStr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
