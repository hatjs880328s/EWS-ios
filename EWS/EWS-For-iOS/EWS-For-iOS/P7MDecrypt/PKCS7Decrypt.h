//
//  PKCS7Decrypt.h
//
//  Created by Zayin Krige on 2017/11/30.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <openssl/bio.h>
#include <openssl/cms.h>
#include <openssl/err.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/crypto.h>
#include <openssl/rand.h>
#import "Security/Security.h"

@interface PKCS7Decrypt : NSObject
/*
decrypts a PKCS7 SMIME container with given private key and certificate
This is just a wrapper function around the pure c code
*/
+ (NSString *)decrypt:(PKCS7 *)encrypted privateKey:(NSString *)privateKey certificate:(NSString *)certificate ;
@end
