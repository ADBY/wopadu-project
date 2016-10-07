//
//  PluginLibrary.mm
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PluginLibrary.h"

#import "CoronaRuntime.h"
#include "CoronaAssert.h"
#include "CoronaEvent.h"
#include "CoronaLua.h"
#include "CoronaLibrary.h"
#include "PluginLibrary.h"



#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>



// ----------------------------------------------------------------------------

@interface CoronaIBeaconDelegate : UIViewController<CLLocationManagerDelegate>

    @property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
    @property (strong, nonatomic) CLLocationManager *locationManager;
    @property (nonatomic, assign) lua_State *luaState;
    @property (nonatomic, strong) NSArray *detectedBeacons;
    @property (nonatomic, unsafe_unretained) void *operationContext;
    @property (nonatomic) Corona::Lua::Ref listenerRef;

    // Correlation id
    @property (nonatomic, assign) NSString *correlationId;
    // Pointer to the current Lua state
    @property (nonatomic, assign) lua_State *L;




    @property (nonatomic, strong) NSArray *arrUUID;
    @property (nonatomic, strong) NSMutableArray *arrBeaconRegion;


    @property (nonatomic, strong) NSString *url;
    @property (nonatomic, strong) NSString *webTitle;
    @property (nonatomic, assign) int currentMajor;
    @property (nonatomic, strong) NSMutableArray *arrBeaconData;



@end



static void * const kMonitoringOperationContext = (void *)&kMonitoringOperationContext;
static void * const kRangingOperationContext = (void *)&kRangingOperationContext;




namespace Corona {
    
CoronaIBeaconDelegate *IBeaconDelegate;

class PluginLibrary
{
	public:
		typedef PluginLibrary Self;

	public:
		static const char kName[];
		static const char kEvent[];

	protected:
		PluginLibrary();

	public:
		bool Initialize( CoronaLuaRef listener );

	public:
		CoronaLuaRef GetListener() const { return fListener; }

	public:
		static int Open( lua_State *L );

	protected:
		static int Finalizer( lua_State *L );

	public:
		static Self *ToLibrary( lua_State *L );

	public:
		static int init( lua_State *L );
		static int scan( lua_State *L );
        static int stopscan( lua_State *L );
        static int getBeacons( lua_State *L );

	private:
		CoronaLuaRef fListener;
    

};

// ----------------------------------------------------------------------------

// This corresponds to the name of the library, e.g. [Lua] require "plugin.library"
const char PluginLibrary::kName[] = "plugin.ibeacon";

// This corresponds to the event name, e.g. [Lua] event.name
const char PluginLibrary::kEvent[] = "pluginibeaconevent";
    
    


PluginLibrary::PluginLibrary()
:	fListener( NULL )
{
}

bool
PluginLibrary::Initialize( CoronaLuaRef listener )
{
	// Can only initialize listener once
	bool result = ( NULL == fListener );

	if ( result )
	{
		fListener = listener;
	}

	return result;
}

int
PluginLibrary::Open( lua_State *L )
{
	// Register __gc callback
	const char kMetatableName[] = __FILE__; // Globally unique string to prevent collision
	CoronaLuaInitializeGCMetatable( L, kMetatableName, Finalizer );

	// Functions in library
	const luaL_Reg kVTable[] =
	{
		{ "init", init },
		{ "scan", scan },
        { "stopscan", stopscan },
        { "getBeacons", getBeacons },

		{ NULL, NULL }
	};

	// Set library as upvalue for each library function
	Self *library = new Self;
	CoronaLuaPushUserdata( L, library, kMetatableName );

	luaL_openlib( L, kName, kVTable, 1 ); // leave "library" on top of stack

	return 1;
}

int
PluginLibrary::Finalizer( lua_State *L )
{
	Self *library = (Self *)CoronaLuaToUserdata( L, 1 );

	CoronaLuaDeleteRef( L, library->GetListener() );

	delete library;

	return 0;
}

PluginLibrary *
PluginLibrary::ToLibrary( lua_State *L )
{
	// library is pushed as part of the closure
	Self *library = (Self *)CoronaLuaToUserdata( L, lua_upvalueindex( 1 ) );
	return library;
}

// [Lua] library.init( listener )
int
PluginLibrary::init( lua_State *L )
{
    int listenerIndex = 1;

     //coronaIBeaconDelegate = [[CoronaIBeaconDelegate alloc] firstRegion];
    if ( CoronaLuaIsListener( L, listenerIndex, kEvent ) )
    {
        
        Self *library = ToLibrary( L );
        
        CoronaLuaRef listener = CoronaLuaNewRef( L, listenerIndex );
        library->Initialize( listener );
        
        
        // Create event and add message to it
        CoronaLuaNewEvent( L, kEvent );
        
        lua_pushstring(L,"init");
        lua_setfield(L, -2, "phase" );
        
        lua_pushboolean(L,true );
        lua_setfield(L, -2, "initialised" );
        
        lua_pushstring( L, "ibeacon intialised" );
        lua_setfield( L, -2, "message" );
        // Dispatch event to library's listener
        CoronaLuaDispatchEvent( L, library->GetListener(), 0 );
        
    }
    
    return 0;
}

// [Lua] library.show( word )
int
PluginLibrary::scan( lua_State *L )
{
    
    int listenerIndex = 1;
     IBeaconDelegate = [[CoronaIBeaconDelegate alloc] init];
    [IBeaconDelegate firstRegion];
    
    if ( CoronaLuaIsListener( L, listenerIndex, kEvent ) )
    {
        
        Self *library = ToLibrary( L );
        
        CoronaLuaRef listener = CoronaLuaNewRef( L, listenerIndex );
        library->Initialize( listener );
        
        
        // Create event and add message to it
        CoronaLuaNewEvent( L, kEvent );
        
        lua_pushstring(L,"scan");
        lua_setfield(L, -2, "phase" );
        
        lua_pushboolean(L,true );
        lua_setfield(L, -2, "scanning" );
        
        lua_pushstring( L, "Scanning Started" );
        lua_setfield( L, -2, "message" );
        // Dispatch event to library's listener
        CoronaLuaDispatchEvent( L, library->GetListener(), 0 );
        
    }
    
    return 0;

}

// [Lua] library.show( word )
int
PluginLibrary::stopscan( lua_State *L )
{
    int listenerIndex = 1;
    [IBeaconDelegate stopRangingForBeacons];
    
    if ( CoronaLuaIsListener( L, listenerIndex, kEvent ) )
    {
        
        Self *library = ToLibrary( L );
        
        CoronaLuaRef listener = CoronaLuaNewRef( L, listenerIndex );
        library->Initialize( listener );
        
        
        // Create event and add message to it
        CoronaLuaNewEvent( L, kEvent );
        
        lua_pushstring(L,"stopscan");
        lua_setfield(L, -2, "phase" );
        
        lua_pushboolean(L,true );
        lua_setfield(L, -2, "scanning" );
        
        lua_pushstring( L, "Scanning Stopped" );
        lua_setfield( L, -2, "message" );
        // Dispatch event to library's listener
        CoronaLuaDispatchEvent( L, library->GetListener(), 0 );
        
    }
    
    return 0;
}
    
// [Lua] library.show( word )
int
PluginLibrary::getBeacons( lua_State *L )
{
    
    int listenerIndex = 1;
   // [coronaIBeaconDelegate stopRangingForBeacons];

    if ( CoronaLuaIsListener( L, listenerIndex, kEvent ) )
    {
        
        Self *library = ToLibrary( L );
        
        CoronaLuaRef listener = CoronaLuaNewRef( L, listenerIndex );
        library->Initialize( listener );
        
        
        // Create event and add message to it
        CoronaLuaNewEvent( L, kEvent );
        
        lua_pushstring(L,"getBeacons");
        lua_setfield(L, -2, "phase" );
        
        
        int index = 1;
        lua_newtable(L);
        int luaTableStackIndex = lua_gettop(L);
        
        for (CLBeacon *beacon in IBeaconDelegate.detectedBeacons) {
            
            NSString *proximity;
            switch (beacon.proximity) {
                case CLProximityNear:
                    proximity = @"Near";
                    break;
                case CLProximityImmediate:
                    proximity = @"Immediate";
                    break;
                case CLProximityFar:
                    proximity = @"Far";
                    break;
                case CLProximityUnknown:
                default:
                    proximity = @"Unknown";
                    break;
            }
            
            
            lua_newtable(L);
            //lua_newtable(0, 0);                                                    //data[1], data[2], etc
           // NSString *UUID = beacon.proximityUUID.UUIDString;
            NSString *testUUID = beacon.proximityUUID.UUIDString;
            const char *UUID = [testUUID UTF8String];
            lua_pushstring(L, UUID);
            lua_setfield(L, -2, "UUID");
            
            const int numMajor = [beacon.major integerValue];
            lua_pushinteger(L,numMajor);
            lua_setfield(L, -2, "Major");
            
            const int numMinor = [beacon.minor integerValue];
            lua_pushinteger(L,numMinor);
            lua_setfield(L, -2, "Minor");
            
            
            //accuracy
            
       //     const int numAccuracy = [beacon.accuracy integerValue];
          //  lua_pushinteger(L,beacon.rssi);
            lua_pushinteger(L,beacon.accuracy);
            lua_setfield(L, -2, "Accuracy");
            
            
            const char *Prox = [proximity UTF8String];
            lua_pushstring(L, Prox);
            lua_setfield(L, -2, "Distance");
            
            lua_rawseti(L, luaTableStackIndex, index);
            index = index + 1;
            
            
        }
        
        lua_setfield(L, -2, "data");
        
        lua_pushinteger(L,index-1);
        lua_setfield(L, -2, "count");
        
        
        // Dispatch event to library's listener
        CoronaLuaDispatchEvent( L, library->GetListener(), 0 );
        
    }
    
    return 0;
}

    
    
// ----------------------------------------------------------------------------
    
    
 } // namespace corona
    


@implementation CoronaIBeaconDelegate




//
//  ViewController.m
//  iBeaconPrototype
//
//  Created by kachane on 7/7/2558 BE.
//  Copyright (c) 2558 kachane. All rights reserved.
//


//static NSString * const kUUID1 = @"74278BDA-B644-4520-8F0C-720EAF059935";
//static NSString * const kUUID1 = @"11111111-B644-4520-8F0C-720EAF059935";
//static NSString * const kUUID2 = @"22222222-B644-4520-8F0C-720EAF059935";

static NSString * const kIdentifier = @"wopado";

//static NSString * const kOperationCellIdentifier = @"OperationCell";
//static NSString * const kBeaconCellIdentifier = @"BeaconCell";
//
//static NSString * const kMonitoringOperationTitle = @"Monitoring";
//static NSString * const kAdvertisingOperationTitle = @"Advertising";
//static NSString * const kRangingOperationTitle = @"Ranging";
//static NSUInteger const kNumberOfSections = 2;
//static NSUInteger const kNumberOfAvailableOperations = 3;

// Create file manager
NSFileManager *fileMgr = [NSFileManager defaultManager];

// Point to Document directory
NSString *documentsDirectory = [NSHomeDirectory()
                                stringByAppendingPathComponent:@"Documents"];

NSError *error;


NSString *filePath = [documentsDirectory
                      stringByAppendingPathComponent:@"myfile.txt"];



//@synthesize beaconDistance;

- (void)firstRegion {
  //  [super firstRegion];
    // Do any additional setup after loading the view, typically from a nib.
    self.arrUUID = [NSArray arrayWithObjects:
                    //                  @"11111111-B644-4520-8F0C-720EAF059935",
                    //                  @"22222222-B644-4520-8F0C-720EAF059935",
                    //                  @"74278BDA-B644-4520-8F0C-720EAF059935",
                    @"B9407F30-F5F8-466E-AFF9-25556B57FE6D",nil];
    self.arrBeaconRegion = [[NSMutableArray alloc] init];
    self.arrBeaconData = [[NSMutableArray alloc] init];
    NSLog(@"show Function");
    self.currentMajor = 0;
    [self startRangingForBeacons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self stopRangingForBeacons];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}



#pragma mark - Table view functionality
- (NSString *)detailsStringForBeacon:(CLBeacon *)beacon
{
    NSString *proximity;
    switch (beacon.proximity) {
        case CLProximityNear:
            proximity = @"Near";
            break;
        case CLProximityImmediate:
            proximity = @"Immediate";
            break;
        case CLProximityFar:
            proximity = @"Far";
            break;
        case CLProximityUnknown:
        default:
            proximity = @"Unknown";
            break;
    }
    
    NSString *format = @"[%@]\n%@, %@ • %@ • %f • %li";
    return [NSString stringWithFormat:format, beacon.proximityUUID.UUIDString, beacon.major, beacon.minor, proximity, beacon.accuracy, beacon.rssi];
}

- (NSArray *)filteredBeacons:(NSArray *)beacons
{
    // Filters duplicate beacons out; this may happen temporarily if the originating device changes its Bluetooth id
    NSMutableArray *mutableBeacons = [beacons mutableCopy];
    
    NSMutableSet *lookup = [[NSMutableSet alloc] init];
    for (int index = 0; index < [beacons count]; index++) {
        CLBeacon *curr = [beacons objectAtIndex:index];
        NSString *identifier = [NSString stringWithFormat:@"%@/%@", curr.major, curr.minor];
        
        // this is very fast constant time lookup in a hash table
        if ([lookup containsObject:identifier]) {
            [mutableBeacons removeObjectAtIndex:index];
        } else {
            [lookup addObject:identifier];
        }
    }
    
    return [mutableBeacons copy];
}

#pragma mark - Common
- (void)createBeaconRegion
{
    //    if (self.beaconRegion1)
    //        return;
    //    if (self.beaconRegion2)
    //        return;
    
    
     NSLog(@"Creating Beacon Region 1...");
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"C0F2E240-836A-489B-A4B1-A0E87FD355BA"];

    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:kIdentifier];
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    beaconRegion.notifyEntryStateOnDisplay = YES;
    [self.arrBeaconRegion addObject:beaconRegion];
}
    



- (void)createLocationManager
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
}

#pragma mark - Beacon ranging
- (void)changeRangingState:sender
{
    UISwitch *theSwitch = (UISwitch *)sender;
    if (theSwitch.on) {
        [self startRangingForBeacons];
    } else {
        [self stopRangingForBeacons];
    }
}

- (void)startRangingForBeacons
{
      NSLog(@"Start Scanning...");
    self.operationContext = kRangingOperationContext;
    
    [self createLocationManager];
    
    [self checkLocationAccessForRanging];
    
    self.detectedBeacons = [NSArray array];
    [self turnOnRanging];
}

- (void)turnOnRanging
{
    NSLog(@"Turning on ranging...");
    
    if (![CLLocationManager isRangingAvailable]) {
        NSLog(@"Couldn't turn on ranging: Ranging is not available.");
        //        self.rangingSwitch.on = NO;
        return;
    }
    
    if (self.locationManager.rangedRegions.count > 0) {
        NSLog(@"Didn't turn on ranging: Ranging already on.");
        return;
    }
    
    [self createBeaconRegion];
    
    for (CLBeaconRegion *beaconRegion in self.arrBeaconRegion) {
        [self.locationManager startRangingBeaconsInRegion: beaconRegion];
        NSLog(@"Ranging turned on for region: %@.", beaconRegion);
    }
    
     NSLog(@"Region Count: %lu.", (unsigned long)self.locationManager.rangedRegions.count );
       //    //beacon1
    //    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion1];
    //
    //    //beacon2
    //    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion2];
    
    //    NSLog(@"Ranging turned on for region: %@.", self.beaconRegion1);
    //    NSLog(@"Ranging turned on for region: %@.", self.beaconRegion2);
    
}

- (void)stopRangingForBeacons
{
    
     NSLog(@"Region Count: %lu.", (unsigned long)self.locationManager.rangedRegions.count );
    if (_locationManager.rangedRegions.count == 0) {
        NSLog(@"Didn't turn off ranging: Ranging already off.");
        return;
    }
    
    
  
    for (CLBeaconRegion *beaconRegion in self.arrBeaconRegion) {
        NSLog(@"Stop Scanning...");
        [_locationManager stopRangingBeaconsInRegion: beaconRegion];
    }
    [self.arrBeaconRegion removeAllObjects];
    

    
    
    //
    //    //beacon1
    //    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion1];
    //
    //    //beacon2
    //    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion2];
    
    //    NSIndexSet *deletedSections = [self deletedSections];
    //    self.detectedBeacons = [NSArray array];
    //
    //    [self.beaconTableView beginUpdates];
    //    if (deletedSections)
    //        [self.beaconTableView deleteSections:deletedSections withRowAnimation:UITableViewRowAnimationFade];
    //    [self.beaconTableView endUpdates];
    
    NSLog(@"Turned off ranging.");
}

#pragma mark - Location access methods (iOS8/Xcode6)
- (void)checkLocationAccessForRanging {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)checkLocationAccessForMonitoring {
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusDenied ||
            authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Missing"
                                                            message:@"Required Location Access(Always) missing. Click Settings to update Location Access."
                                                           delegate:self
                                                  cancelButtonTitle:@"Settings"
                                                  otherButtonTitles:@"Cancel", nil];
            [alert show];
            //            self.monitoringSwitch.on = NO;
            return;
        }
        [self.locationManager requestAlwaysAuthorization];
    }
}

#pragma mark - Location manager delegate methods
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        if (self.operationContext == kMonitoringOperationContext) {
            NSLog(@"Couldn't turn on monitoring: Location services are not enabled.");
            //            self.monitoringSwitch.on = NO;
            return;
        } else {
            NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
            //            self.rangingSwitch.on = NO;
            return;
        }
    }
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    switch (authorizationStatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
            if (self.operationContext == kMonitoringOperationContext) {
                //                self.monitoringSwitch.on = YES;
            } else {
                //                self.rangingSwitch.on = YES;
            }
            return;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (self.operationContext == kMonitoringOperationContext) {
                NSLog(@"Couldn't turn on monitoring: Required Location Access(Always) missing.");
                //                self.monitoringSwitch.on = NO;
            } else {
                //                self.rangingSwitch.on = YES;
            }
            return;
            
        default:
            if (self.operationContext == kMonitoringOperationContext) {
                NSLog(@"Couldn't turn on monitoring: Required Location Access(Always) missing.");
                //                self.monitoringSwitch.on = NO;
                return;
            } else {
                NSLog(@"Couldn't turn on monitoring: Required Location Access(WhenInUse) missing.");
                //                self.rangingSwitch.on = NO;
                return;
            }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    NSArray *filteredBeacons = [self filteredBeacons:beacons];
    
    if (filteredBeacons.count == 0) {
        NSLog(@"No beacons found nearby.");
      
    } else {
        NSLog(@"Found %lu %@.", (unsigned long)[filteredBeacons count],
              [filteredBeacons count] > 1 ? @"beacons" : @"beacon");
    }
    
    //    NSIndexSet *insertedSections = [self insertedSections];
    //    NSIndexSet *deletedSections = [self deletedSections];
    //    NSArray *deletedRows = [self indexPathsOfRemovedBeacons:filteredBeacons];
    //    NSArray *insertedRows = [self indexPathsOfInsertedBeacons:filteredBeacons];
    //    NSArray *reloadedRows = nil;
    //    if (!deletedRows && !insertedRows)
    //        reloadedRows = [self indexPathsForBeacons:filteredBeacons];
    
    //display beacons count
   // self.beaconCount.text = [NSString stringWithFormat:@"Found %li beacon(s).", beacons.count];
    
    self.detectedBeacons = filteredBeacons;
    //    self.detectedBeacons = beacons;
    
    NSString *output = @"";
    for (CLBeacon *beacon in self.detectedBeacons) {
        
        output = [NSString stringWithFormat:@"%@%@\n", output, [self detailsStringForBeacon:beacon]];
    }
    NSLog(@"%@",output);
 //   self.beaconDistance.text = output;
    
    int i = 0;
    for (CLBeacon *beacon in self.detectedBeacons) {
        //       NSString *proximity;
        
        NSString *uuid = beacon.proximityUUID.UUIDString;
        NSString *strMajor = beacon.major.stringValue;
        NSString *strMinor = beacon.minor.stringValue;
        NSString *rssiValue = [NSString stringWithFormat:@"%i", beacon.rssi];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"uuid like %@ AND major like %@", uuid, strMajor];
        NSArray *matchingDicts = [self.arrBeaconData filteredArrayUsingPredicate:predicate];
        NSDictionary *dicBeacon = [matchingDicts lastObject];
        NSString *strProximity = [dicBeacon objectForKey:@"proximity"];
        NSLog(@"dicBeacon: %@", dicBeacon);
        NSString *ProxStr = @"Ime";
        
       
        
        
        
        
        BOOL isOpenUrl = NO;
        if(beacon.proximity == CLProximityUnknown) {
           // isOpenUrl = self.isOpenWebView;
        } else {
            if([strProximity isEqualToString:@"CLProximityImmediate"]) {
                if(beacon.proximity == CLProximityImmediate) {
                    isOpenUrl = YES;
                    
                   
                    
                    
                }
            } else if ([strProximity isEqualToString:@"CLProximityNear"]) {
                if(beacon.proximity == CLProximityNear || beacon.proximity == CLProximityImmediate) {
                    isOpenUrl = YES;
                }
            } else if ([strProximity isEqualToString:@"Far"]) {
                if(beacon.proximity == CLProximityFar || beacon.proximity == CLProximityNear || beacon.proximity == CLProximityImmediate) {
                    isOpenUrl = YES;
                }
            } else {
             //   isOpenUrl = self.isOpenWebView;
            }
        }
        
        
        if(beacon.proximity == CLProximityUnknown){
        
         ProxStr = @"UN";
        
        
        } else if (beacon.proximity == CLProximityImmediate){
        
            ProxStr = @"Ime";
        
        } else if (beacon.proximity == CLProximityNear){
        
            ProxStr = @"Near";
            
        } else if (beacon.proximity == CLProximityFar){
        
            ProxStr = @"Far";
        
        }
        
        
      //  NSError *error;
        NSString *stringToWrite = [NSString stringWithFormat: @"%@", strMajor];
      //  NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"myfile.txt"];
     //   [stringToWrite writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
        
        
        [stringToWrite writeToFile:filePath atomically:YES
                encoding:NSUTF8StringEncoding error:&error];
        
        
        if ( NULL != self.listenerRef )
        {
        // Create the event
        Corona::Lua::NewEvent( self.L, "finalData" );
        NSLog(@"dicBeacon varun raja");
        
        // Push the canceled event
        lua_pushstring( self.L, "canceled" );
        lua_setfield( self.L, -2, "state" );
        
        // Dispatch the event
        Corona::Lua::DispatchEvent( self.L, self.listenerRef, 1 );
        
        // Free native reference to listener
        Corona::Lua::DeleteRef( self.L, self.listenerRef );
        
        // Null the reference
        self.listenerRef = NULL;
        }
        
        [self stopRangingForBeacons];
        
        int major = [strMajor intValue];
        if(isOpenUrl) {
            //NSString *uuid = beacon.proximityUUID.UUIDString;
            
            //            int minor = (int)beacon.minor;
            //may
            /*switch (major) {
             case 1:
             self.webTitle = @"HYATT";
             self.url = @"http://www.diydevhowto.com/shop/hyatt/";
             
             break;
             case 2:
             self.webTitle = @"WOPADO";
             self.url = @"http://www.diydevhowto.com/shop/wopado/";
             
             break;
             default:
             self.webTitle = @"LANLARB";
             self.url = @"http://www.diydevhowto.com/shop/lanlarb/";
             break;
             }*/
            self.url = [dicBeacon objectForKey:@"url"];
            
            
            //            if(!self.isOpenWebView) {
            //                self.isOpenWebView = YES;
            //                [self performSegueWithIdentifier:@"nextView" sender:self];
            //            }
            
            if(major != self.currentMajor) {
                self.currentMajor = major;
                self.webTitle = [dicBeacon objectForKey:@"title"];
                [self performSegueWithIdentifier:@"nextView" sender:self];
            }
            
            //            if(uuid == [self.arrUUID objectAtIndex:0]) {
            //                self.url = @"http://www.diydevhowto.com/shop/hyatt/";
            //            } else if (uuid == [self.arrUUID objectAtIndex:1]) {
            //                self.url = @"http://www.diydevhowto.com/shop/wopado/";
            //            } else {
            //                self.url = @"http://www.diydevhowto.com/shop/wopado/";
            //            }
        } else {
            
        }
        
        //        NSString *format = @"[%@]\n%@, %@ • %@ • %f • %li";
        //        return [NSString stringWithFormat:format, beacon.proximityUUID.UUIDString, beacon.major, beacon.minor, proximity, beacon.accuracy, beacon.rssi];
        i++;
    }
    
    //    if(beacons.count > 0)
    //    {
    //
    //        CLBeacon *beacon1 = self.detectedBeacons[0];
    //
    //        NSString *output = @"";
    //
    //        if (self.detectedBeacons.count > 1) {
    //            CLBeacon *beacon2 = self.detectedBeacons[1];
    //            output = [NSString stringWithFormat:@"%@\n%@", [self detailsStringForBeacon:beacon1], [self detailsStringForBeacon:beacon2]];
    //        } else {
    //            output = [NSString stringWithFormat:@"%@", [self detailsStringForBeacon:beacon1]];
    //        }
    //
    //
    //        NSLog(output);
    //        self.beaconDistance.text = output;
    //    }
    //
    //    if(beacons.count > 0)
    //    {
    //        if(!self.isOpenWebView) {
    //            self.isOpenWebView = YES;
    //            [self performSegueWithIdentifier:@"nextView" sender:self];
    //        }
    //    }
    
    //    [self.beaconTableView beginUpdates];
    //    if (insertedSections)
    //        [self.beaconTableView insertSections:insertedSections withRowAnimation:UITableViewRowAnimationFade];
    //    if (deletedSections)
    //        [self.beaconTableView deleteSections:deletedSections withRowAnimation:UITableViewRowAnimationFade];
    //    if (insertedRows)
    //        [self.beaconTableView insertRowsAtIndexPaths:insertedRows withRowAnimation:UITableViewRowAnimationFade];
    //    if (deletedRows)
    //        [self.beaconTableView deleteRowsAtIndexPaths:deletedRows withRowAnimation:UITableViewRowAnimationFade];
    //    if (reloadedRows)
    //        [self.beaconTableView reloadRowsAtIndexPaths:reloadedRows withRowAnimation:UITableViewRowAnimationNone];
    //    [self.beaconTableView endUpdates];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entered region: %@", region);
    
    //    [self sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exited region: %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSString *stateString = nil;
    switch (state) {
        case CLRegionStateInside:
            stateString = @"inside";
            break;
        case CLRegionStateOutside:
            stateString = @"outside";
            break;
        case CLRegionStateUnknown:
            stateString = @"unknown";
            break;
    }
    NSLog(@"State changed to %@ for region %@.", stateString, region);
}

@end






CORONA_EXPORT int luaopen_plugin_ibeacon( lua_State *L )
{
	return Corona::PluginLibrary::Open( L );
}
