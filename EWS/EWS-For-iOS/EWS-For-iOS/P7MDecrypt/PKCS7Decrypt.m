//
//  PKCS7Decrypt.m
//
//  Created by Zayin Krige on 2017/11/30.
//

#import "PKCS7Decrypt.h"
#import "SMimeDecrypt.h"

@implementation PKCS7Decrypt

+ (NSString *)decrypt:(PKCS7 *)encrypted privateKey:(NSString *)privateKey certificate:(NSString *)certificate {
    const char *pk = [privateKey UTF8String];
    const char *cert = [certificate UTF8String];
    const char *decrypted = decrypt_smime(encrypted, pk, cert);
    if (decrypted) {
        return [NSString stringWithUTF8String:decrypted];
    } else {
        return nil;
    }
}


+(PKCS7 *)encrypt: (BIO *)strBIO certificate:(NSString *)certificate {
//    const char *str = [strValue UTF8String];
    const char *cert = [certificate UTF8String];
    PKCS7 *encrypted = encryptd(cert, strBIO);
    if (encrypted) {
        return encrypted;
    } else {
        return nil;
    }
}

@end
