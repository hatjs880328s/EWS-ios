//
//  PKCS12.m
//  EWS-For-iOS
//
//  Created by Noah_Shan on 2018/12/5.
//  Copyright © 2018 wangxk. All rights reserved.
//

#import "PKCS12.h"
#import <CommonCrypto/CommonDigest.h>

#import <CommonCrypto/CommonCryptor.h>

#import <Security/Security.h>

//#import "NSData+Base64.h"
#define kChosenDigestLength CC_SHA1_DIGEST_LENGTH  // SHA-1消息摘要的数据位数160位

@implementation PKCS12

/// 私钥加签
-(NSString *)signTheDataSHA1WithRSA:(NSString *)plainText
{
    uint8_t* signedBytes = NULL;
    size_t signedBytesSize = 0;
    OSStatus sanityCheck = noErr;
    NSData* signedHash = nil;

    NSString * path = [[NSBundle mainBundle]pathForResource:@"ppp" ofType:@"p123"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    //因为pfx之前设置的有密码所以这里要设置一下
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init]; // Set the private key query dictionary.
    [options setObject:@"123456" forKey:(id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((CFDataRef) data, (CFDictionaryRef)options, &items);
    if (securityError!=noErr) {
        return nil ;
    }
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
    SecKeyRef privateKeyRef=nil;
    SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
    signedBytesSize = SecKeyGetBlockSize(privateKeyRef);

    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];

    signedBytes = malloc( signedBytesSize * sizeof(uint8_t) ); // Malloc a buffer to hold signature.
    memset((void *)signedBytes, 0x0, signedBytesSize);

    sanityCheck = SecKeyRawSign(privateKeyRef,
                                kSecPaddingPKCS1SHA1,
                                (const uint8_t *)[[self getHashBytes:plainTextBytes] bytes],
                                CC_SHA1_DIGEST_LENGTH,
                                (uint8_t *)signedBytes,
                                &signedBytesSize);

    if (sanityCheck == noErr)
    {
        signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedBytesSize];
    }
    else
    {
        return nil;
    }

    if (signedBytes)
    {
        free(signedBytes);
    }
    NSString *signatureResult=@"fdaf";//[NSString stringWithFormat:@"%@",[signedHash base64EncodedString]];

    return signatureResult;
}

- (NSData *)getHashBytes:(NSData *)plainText {
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;

    // Malloc a buffer to hold hash.
    hashBytes = malloc( CC_SHA1_DIGEST_LENGTH * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, kChosenDigestLength);
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[plainText bytes], [plainText length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);

    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kChosenDigestLength];
    if (hashBytes) free(hashBytes);

    return hash;
}

/// 公钥验证签名
BOOL PKCSVerifyBytesSHA1withRSA(NSData* plainData, NSData* signature, SecKeyRef publicKey)
{
    size_t signedHashBytesSize = SecKeyGetBlockSize(publicKey);
    const void* signedHashBytes = [signature bytes];

    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA1([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }

    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingPKCS1SHA1,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);

    return status == errSecSuccess;
}

- (SecKeyRef)getPublicKey {

    NSString * path = [[NSBundle mainBundle]pathForResource:@"ppp" ofType:@"p123"];
    NSData * data = [NSData dataWithContentsOfFile:path];

    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    extractIdentityAndTrust((__bridge CFDataRef)data, &myIdentity, &myTrust);

    SecKeyRef publicKey;
    publicKey = SecTrustCopyPublicKey(myTrust);

    return publicKey;
}

OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust)
{
    OSStatus securityError = errSecSuccess;

    CFStringRef password = CFSTR("123456");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };

    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);

    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12data, options, &items);

    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *trust = (SecTrustRef)tempTrust;
    }

    if (options) {
        CFRelease(options);
    }

    return securityError;
}


@end
