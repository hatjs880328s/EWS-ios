//
//  SMimeDecrypt.h
//  impcloud
//
//  Created by Noah_Shan on 2018/12/7.
//  Copyright © 2018 Elliot. All rights reserved.
//

#ifndef SMimeDecrypt_h
#define SMimeDecrypt_h
#include <stdio.h>
#include <openssl/bio.h>
#include <openssl/cms.h>
#include <openssl/err.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/crypto.h>
#include <openssl/rand.h>
#import "Security/Security.h"


char *decrypt_smime(PKCS7 *encrypted, const char *privateKey, const char *certificate);

PKCS7 *encryptd(const char *certificate, BIO *indata);

#endif /* SMimeDecrypt_h */
