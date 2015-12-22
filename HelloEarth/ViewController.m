//
//  ViewController.m
//  HelloEarth
//
//  Created by Dacio Jose Leal Rodriguez on 22/12/15.
//  Copyright © 2015 Dacio Leal Rodriguez. All rights reserved.
//

#import "ViewController.h"
#import "WhirlyGlobeComponent.h"


@interface ViewController () {
    
    WhirlyGlobeViewController *whirlyGlobeVC;
    MaplyComponentObject *object;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    whirlyGlobeVC = [[WhirlyGlobeViewController alloc] init];
    whirlyGlobeVC.view.frame = self.view.bounds;
    self.title = @"Globe";
    whirlyGlobeVC.keepNorthUp = YES;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(addMark)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    UIBarButtonItem *removeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(removeMark)];
    self.navigationItem.leftBarButtonItem = removeBtn;
    
    
    [self addChildViewController:whirlyGlobeVC];
    [self.view addSubview:whirlyGlobeVC.view];
    
    
    bool useLocalTiles = false;
    
    MaplyQuadImageTilesLayer *layer;
    
    if (useLocalTiles) {
        
        MaplyMBTileSource *tileSource = [[MaplyMBTileSource alloc] initWithMBTiles:@"geography-class_medres"];
        
        layer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
        
    } else {
        
        NSString *baseCacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *aerialTilesCacheDir = [NSString stringWithFormat:@"%@/osmtiles/", baseCacheDir];
        
        int maxZoom = 18;
        
        MaplyRemoteTileSource *tileSource = [[MaplyRemoteTileSource alloc] initWithBaseURL:@"http://otile1.mqcdn.com/tiles/1.0.0/sat/" ext:@"png" minZoom:0 maxZoom:maxZoom];
        tileSource.cacheDir = aerialTilesCacheDir;
        
        layer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    }
    
    layer.handleEdges = true;
    layer.coverPoles = true;
    layer.requireElev = false;
    layer.waitLoad = false;
    layer.drawPriority = 0;
    layer.singleLevelLoading = false;
    [whirlyGlobeVC addLayer:layer];
    
    whirlyGlobeVC.rotateGesture = false;
    
}

- (void) addMark {
    
    NSLog(@"Add");
    
    MaplyScreenMarker *marker = [[MaplyScreenMarker alloc] init];
    marker.image = [UIImage imageNamed:@"ico_localizacion.png"];
    marker.size = CGSizeMake(20.0, 20.0);
    marker.loc = MaplyCoordinateMakeWithDegrees(3.0, 40.0);
    marker.layoutImportance = MAXFLOAT;
    
    object = [whirlyGlobeVC addScreenMarkers:@[marker] desc:nil];
    
    
}

- (void) removeMark {
    
    NSLog(@"Remove");
    
    if (object) {
        [whirlyGlobeVC removeObject:object];
        object = nil;
    }
}



@end
