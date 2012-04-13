//
//  ShakeXMLCreateor.m
//  ShakeMobile
//
//  Created by he yk on 3/20/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import "ShakeXMLCreateor.h"
#import "GDataXMLNode.h"
@implementation ShakeXMLCreateor


+ (NSString*)stringXMLWithRootElement:(GDataXMLElement*)rootElement {
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] 
                                   initWithRootElement:rootElement] autorelease];
    NSData *data = [document XMLData];
    NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    return str;
}

//<?xml version="1.0"?>
//<regfamilybyshark>
//<familyname>yuri</familyname>
//<latitude>1000</latitude>
//<longitude>1000</longitude>
//</regfamilybyshark>
+(NSString*)adminShakeXMLCreate:(NSString*)deviceName 
                   adminLatitue:(NSString*)latitude 
                 adminLongitude:(NSString*)longitude{

    
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"regfamilybyshark"];
    
    GDataXMLElement *familynameElement = [GDataXMLNode elementWithName:@"familyname" stringValue:deviceName];
 
    GDataXMLElement *latitudeElement = [GDataXMLNode elementWithName:@"latitude" stringValue:latitude];
    GDataXMLElement *longitudeElement = [GDataXMLNode elementWithName:@"longitude" stringValue:longitude];
    
    [rootElement addChild:familynameElement];
    [rootElement addChild:latitudeElement];
    [rootElement addChild:longitudeElement];
    
    return [ShakeXMLCreateor stringXMLWithRootElement:rootElement];
}

//<?xml version="1.0"?>
//<regfamilybyshark>
//<latitude>1000</latitude>
//<longitude>1000</longitude>
//</regfamilybyshark>
+(NSString*)memberShakeXMLCreateLatitue:(NSString*)latitude 
                        memberLongitude:(NSString*)longitude{

    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"findfamilybyshark"];

    GDataXMLElement *latitudeElement = [GDataXMLNode elementWithName:@"latitude" stringValue:latitude];
    GDataXMLElement *longitudeElement = [GDataXMLNode elementWithName:@"longitude" stringValue:longitude];

    [rootElement addChild:latitudeElement];
    [rootElement addChild:longitudeElement];
    
    return [ShakeXMLCreateor stringXMLWithRootElement:rootElement];
}
@end
