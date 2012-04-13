//
//  ShakeXMLParser.m
//  ShakeMobile
//
//  Created by he yk on 3/20/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import "ShakeXMLParser.h"
#import "GDataXMLNode.h"


@implementation ShakeXMLParser

+ (ShakeRecieveDataVO*)parseAdminShakeResult:(NSData*)aData;{
    
    ShakeRecieveDataVO *recieveData = [[[ShakeRecieveDataVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//regfamilybysharkresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        NSString *result = [node stringValue];
        if ([result isEqualToString:@"ok"]) {
            recieveData.addOK = YES;
        }
        else {
            recieveData.addOK = NO;
        }
        
        break;
    }
    
    
    
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//regfamilybysharkresult/familyname" error:nil];
    for (GDataXMLNode *node in nodesArray2) {
        recieveData.familyName = [node stringValue];
        break;
    }
    
    return recieveData;
}
+ (ShakeRecieveDataVO*)parseMemberShakeResult:(NSData*)aData{
    ShakeRecieveDataVO *recieveData = [[[ShakeRecieveDataVO alloc] init] autorelease];
    
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//findfamilybysharkresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        NSString *result = [node stringValue];
        if ([result isEqualToString:@"ok"]) {
            recieveData.addOK = YES;
        }
        else {
            recieveData.addOK = NO;
        }
        
        break;
    }
    
    
    
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//findfamilybysharkresult/familyname" error:nil];
    for (GDataXMLNode *node in nodesArray2) {
        recieveData.familyName = [node stringValue];
        break;
    }
    
    return recieveData;
}

@end
