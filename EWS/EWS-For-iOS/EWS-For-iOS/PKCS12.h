//
//  PKCS12.h
//  EWS-For-iOS
//
//  Created by Noah_Shan on 2018/12/5.
//  Copyright © 2018 wangxk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKCS12 : NSObject

- (SecKeyRef)getPublicKey ;

-(NSString *)signTheDataSHA1WithRSA:(NSString *)plainText ;


@end
