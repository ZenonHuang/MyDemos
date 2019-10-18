//
//  ViewController.m
//  BluetoothForKeyboard
//
//  Created by ZenonHuang on 2019/10/17.
//  Copyright © 2019 zenon. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define feizhiServiceUUID @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define feizhiWriteUUID   @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define feizhiNotifyUUID  @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"


@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic,strong)  CBCentralManager *centralManager;
@property (nonatomic,strong)  CBPeripheral *peripheral;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
//                             [NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey,nil];
    
    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                            queue:nil
                                                                          options:nil];
    self.centralManager = centralManager;
    
 }


#pragma mark - private
- (BOOL)isFeizhiDevice:(NSString *)name
{
    NSString *deviceName = [name uppercaseString];
    if ([deviceName containsString:@"FEIZHI"]) {
        return YES;
    }
    
    if ([deviceName containsString:@"FDM"]) {
        return YES;
    }
    
    if ([deviceName containsString:@"FLYDIGI"]) {
        return YES;
    }
    
    
    return NO;
}

- (BOOL)isFeizhiQ1D1:(NSString *)name
{
    NSString *deviceName = [name uppercaseString];
    if ([deviceName containsString:@"Q1"]) {
        return YES;
    }
    
    if ([deviceName containsString:@"D1"]) {
        return YES;
    }
    
    return NO;
}


#pragma mark - CBCentralManagerDelegate

//必须实现,如果  CBCentralManager 初始化成功则会回调这里
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState...");
    if (@available(iOS 10.0, *)) {
        if (central.state == CBManagerStatePoweredOn) {
            //PowerOn 状态 ,开始扫描周边设备
            //可以使用指定的 UUID 发现特定的 Service，也可以传入 nil，表示发现所有周边的蓝牙设备
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        }
    } else {
        // Fallback on earlier versions
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

//发现 Service 后，回调这里
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
//     [self.centralManager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180D"]]];
    
//    NSLog(@"centralManager didDiscoverPeripheral -> Discovered: %@", peripheral.name);
//      NSLog(@"centralManager advertisementData: %@", advertisementData);
    
    //已经被系统或者其他APP连接上的设备数组
        //不生效
        //[CBUUID UUIDWithString:@"180A"]
        //[CBUUID UUIDWithString:feizhiServiceUUID]
    NSArray *arr = [self.centralManager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180A"],[CBUUID UUIDWithString:@"2A23"]]];
    if (arr.count>0) {
        //    [self.centralManager stopScan];
        //    [self.centralManager start];
        for (CBPeripheral *obj in arr) {
            //        obj.delegate = self;
            //        [obj discoverServices:@[[CBUUID UUIDWithString:feizhiServiceUUID]]];
            
            //        [self.centralManager cancelPeripheralConnection:obj];
            obj.delegate = self;
            self.peripheral = obj;
            [self.centralManager  connectPeripheral:obj options:nil];
            
            //        [self.centralManager registerForConnectionEventsWithOptions:<#(nullable NSDictionary<CBConnectionEventMatchingOption,id> *)#>];
        }
        // [CBUUID UUIDWithString:@"2A23"]
        //    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
  
        
    
    
    if (!peripheral.name){
        return; // Ingore name is nil peripheral.
    }
    
   //成功发现设备后，选择需要的 peripheral
    if (![self isFeizhiDevice:peripheral.name]) {
        return;
    }
    
    if (![self isFeizhiQ1D1:peripheral.name]) {
        return;
    }
 
    NSLog(@"peripheral name %@ ",peripheral.name);
    NSLog(@"peripheral service %@ ",peripheral.services);
    
    for (CBService *serviceObj in peripheral.services) {
        NSLog(@"peripheral service uuid %@ ",serviceObj.UUID);
    }
    BOOL  hasConnected = NO;
    BOOL  isConnecting = NO;
    if (@available(iOS 10.0, *)) {
       hasConnected = (peripheral.state == CBPeripheralStateConnected);
       isConnecting = (peripheral.state == CBPeripheralStateConnecting);
    }
    self.peripheral = peripheral;
    
    if (hasConnected||isConnecting) {//已经连接，进行注册
        
    }else{
        //未连接，进行建立连接.在建立连接之后停止发现
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    

    
}

// peripheral 连接成功后调用
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    self.peripheral.delegate = self;

    CBUUID *seriveUUID = [CBUUID UUIDWithString:feizhiServiceUUID];
    //获取服务和特征
    [self.peripheral discoverServices:@[seriveUUID]];
}

//外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
    
}

//丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"%s, line = %d, %@=断开连接", __FUNCTION__, __LINE__, peripheral.name);
    
    [self.centralManager connectPeripheral:peripheral options:nil];               //重新连接
    
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    for (CBPeripheral *obj in peripherals) {
           NSLog(@"%@",obj);
    }
}

- (void)centralManager:(CBCentralManager *)central connectionEventDidOccur:(CBConnectionEvent)event forPeripheral:(CBPeripheral *)peripheral
{
      NSLog(@"DidOccur %@",peripheral);
}
- (void)centralManager:(CBCentralManager *)central didUpdateANCSAuthorizationForPeripheral:(CBPeripheral *)peripheral
{
      NSLog(@"ANCSAuthor %@",peripheral);
}

//- (void)centralManager:(CBCentralManager *)central willRestoreState:(nonnull NSDictionary<NSString *,id> *)dict
//{
//     NSLog(@"willRestoreState");
//}
#pragma mark - CBPeripheralDelegate

// 发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        return;
    }
    
    NSArray *services = peripheral.services;

    if (services) {

        
        //监听需要的服务
        for (CBService *serviceObj in peripheral.services) {
            NSLog(@"peripheral service uuid %@ ",serviceObj.UUID);
            [peripheral discoverCharacteristics:nil forService:serviceObj];
        }
        
    }
}

// 发现获取特征
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"Discover Charactertics Error : %@", error);
        return;
    }
    
    //发现特征
    //注意：uuid 分为可读，可写，要区别对待！！！
    NSArray *characteristicArray = service.characteristics;
    
    NSLog(@"service %@",service.UUID);
    
    for ( CBCharacteristic *characteristic in characteristicArray) {
        NSLog(@"%@",characteristic.UUID);
        
        //通知监听
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:feizhiNotifyUUID]])
        {
            NSLog(@"监听：%@",characteristic);//监听特征

            //以后发信息也是用这个uuid
            CBCharacteristic *notifyCharacteristic = characteristic;
            //打开通知特性，否者写入数据之后，不会收到回复数据。  可以监听多个
            [peripheral setNotifyValue:YES forCharacteristic:notifyCharacteristic];
        }
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:feizhiWriteUUID]]) {
            //写入数据
            CBCharacteristic *writeCharactersitc = characteristic;
        
        
            SignedByte byte[] = {-84, -17,  0};
            NSData *writeData = [NSData dataWithBytes:byte length:3];
            
            
            [peripheral writeValue:writeData.copy
                 forCharacteristic:writeCharactersitc
                              type:CBCharacteristicWriteWithResponse];
            
            [peripheral writeValue:writeData.copy
                           forCharacteristic:writeCharactersitc
                                        type:CBCharacteristicWriteWithoutResponse];
        }
    }

    
}


// 写入成功后的应答
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    if (characteristic.value.length!=14) {
        return;
    }
    NSLog(@"收到的数据：%@",characteristic.value);
    NSData *inputData =characteristic.value;
    
    NSUInteger len = [inputData length];
//    Byte *byteData = (Byte*)malloc(len);
//    memcpy(byteData, [inputData bytes], len);
//    NSLog(@"byte %@",@(byteData[0]));
    
    Byte *byte =  (Byte *) [inputData bytes];
    
    //每一位 0-255
    int mouse1 = byte[len-1]&0xff;
    int mouse2 = byte[len-2]&0xff;//y
    int mouse3 = byte[len-3]&0xff;//x
    
    NSLog(@"mouse input %d %d %d",mouse3,mouse2,mouse1);
    
    // 右移动为正数，左移动为负数
    int offsetX = 0;
    int i5 = (mouse3 & 255) | ((mouse2 << 8) & 3840);
    if ((i5 & 2048) != 0) {
        offsetX = i5 | -4096;
    } else {
        offsetX = i5;
    }
    
    NSLog(@"mouse offsetX %@",@(offsetX));
    //上一动为负数，下移动为正数
    int offsetY = ((mouse2 >> 4) & 15) | ((mouse1 << 4) & 4080);
    if ((offsetY & 2048) != 0) {
        offsetY |= -4096;
    }
    
    
    //128初始
    int mouseWheel = byte[9]&0xff;
    
    NSLog(@"mouse wheel %@",@(mouseWheel));
    if (mouseWheel==129) {//鼠标左键按下
        
    }
    if (mouseWheel==130) {//鼠标右键按下
        
    }
    
    
    if (mouseWheel==132) {//鼠标中键按下
        
    }
    if (mouseWheel==192) {//滚轮向下
        
    }
    if (mouseWheel==160) {//滚轮向上
        
    }
    
  
    //键盘支持同时五个按键
    int button1 = byte[1];
    int button2 = byte[2];
    int button3 = byte[3];
    int button4 = byte[4];
    int button5 = byte[5];
    
    //只有一个键从第 5 位开始
    NSLog(@"button5 %@",@(button5));
    NSLog(@"button4 %@",@(button4));
    NSLog(@"button3 %@",@(button3));
    NSLog(@"button2 %@",@(button2));
    NSLog(@"button1 %@",@(button1));
    
}

// 写入成功
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(nullable NSError *)error {
    if (!error) {
        NSLog(@"Write Success");
    } else {
        NSLog(@"WriteVale Error = %@", error);
    }
}


@end
