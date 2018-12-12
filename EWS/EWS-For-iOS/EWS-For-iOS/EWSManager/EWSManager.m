//
// EWSManager.m
// EWS-For-iOS
//
// Copyright (c) 2016 wangxk
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "EWSManager.h"
#import "EWSAutodiscover.h"
#import "EWSInboxList.h"
#import "EWSItemContent.h"
#import "EWSMailAttachment.h"

static EWSManager *instance = nil;

typedef void (^ManagerGetAllItemContentBlock)(NSArray *allItemArray, NSError *error);
typedef void (^ManagerGetItemContentBlock)(EWSItemContentModel *model, NSError *error);
typedef void (^ManagerGetAllAttachmentCompleteBlock)(void);
typedef void (^ManagerGetInboxListBlock)(NSArray *inboxList, NSError *error);
typedef void (^ManagerGetAttachmentCompleteBlock)(void);

@implementation EWSManager{
    NSArray *_inboxList;
    NSMutableArray *_allItemContentArray;
    NSError *_error;
    
    ManagerGetAllItemContentBlock _managerGetAllItemContentBlock;
    ManagerGetItemContentBlock _managerGetItemContentBlock;
    ManagerGetAllAttachmentCompleteBlock _managerGetAllAttachmentCompleteBlock;
    ManagerGetInboxListBlock _managerGetInboxListBlock;
    ManagerGetAttachmentCompleteBlock _managerGetAttachmentCompleteBlock;
}

@synthesize ewsEmailBoxModel;

-(instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }

    return self;
}

+(id)sharedEwsManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[EWSManager alloc] init];
    });
    return instance;
}

-(void)setEmailBoxInfoEmailAddress:(NSString *)emailAddress
                          password:(NSString *)password
                       description:(NSString *)description
                 mailServerAddress:(NSString *)mailServerAddress
                            domain:(NSString *)domain
                        completion:(void(^)(BOOL success))completion {
    ewsEmailBoxModel = [[EWSEmailBoxModel alloc] init];
    ewsEmailBoxModel.emailAddress = emailAddress;
    ewsEmailBoxModel.password = password;
    ewsEmailBoxModel.mailBoxDescription = description;
    ewsEmailBoxModel.mailServerAddress = mailServerAddress;
    ewsEmailBoxModel.domain = domain;
    
    if (!(ewsEmailBoxModel.emailAddress&&ewsEmailBoxModel.password)) {
        NSLog(@"emailAddress and password can't be nil");
        completion(false);
    }
    else if (/* DISABLES CODE */ (1)||[ewsEmailBoxModel.mailServerAddress isEqualToString:@""]) {
        [self autodiscoverWithCompletion:completion];
    }
    
}

-(void)autodiscoverWithCompletion:(void(^)(BOOL success))completion {
    [[[EWSAutodiscover alloc] init] autoDiscoverWithEmailAddress:ewsEmailBoxModel.emailAddress finishBlock:^(NSString *ewsUrl, NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            completion(false);
            return;
        }
        NSLog(@"EWSUrl: %@", ewsUrl);
        self->ewsEmailBoxModel.mailServerAddress = ewsUrl;
        completion(true);
    }];
}

-(void)getInboxListComplete:(void (^)(NSArray *inboxList, NSError *error))managerGetInboxListBlock{
    _managerGetInboxListBlock = managerGetInboxListBlock;
    [[[EWSInboxList alloc] init] getInboxListWithEWSUrl:ewsEmailBoxModel.mailServerAddress finishBlock:^(NSMutableArray *inboxList, NSError *error) {
        if (error) {
            self->_error = error;
        }
        else{
            self->_error = nil;
        }
        if (self->_managerGetInboxListBlock) {
            self->_managerGetInboxListBlock([inboxList copy],error);
            [inboxList removeAllObjects];
            inboxList = nil;
        }
        
    }];
    
}

-(void)getItemnContentWithInboxListModel:(EWSInboxListModel *)model complete:(void (^)(EWSItemContentModel *model, NSError *error))managerGetItemContentBlock{
    _managerGetItemContentBlock = managerGetItemContentBlock;
    [[[EWSItemContent alloc] init] getItemContentWithEWSUrl:ewsEmailBoxModel.mailServerAddress item:model finishBlock:^(EWSItemContentModel *itemContentInfo, NSError *error) {
        if (error) {
            self->_error = error;
        }
        else{
            self->_error = nil;
        }
        if (self->_managerGetItemContentBlock) {
            self->_managerGetItemContentBlock(itemContentInfo, self->_error);
        }
    }];
}


///获取所有邮件列表[没详情信息只有 id & folderid ]
-(void)getAllItemContent:(void (^)(NSArray *allItemArray, NSError *error))managerGetAllItemContentBlock{
    _managerGetAllItemContentBlock = managerGetAllItemContentBlock;
    [[[EWSInboxList alloc] init] getInboxListWithEWSUrl:ewsEmailBoxModel.mailServerAddress finishBlock:^(NSMutableArray *inboxList, NSError *error) {
        if (error) {
            NSLog(@"GetInboxListError:%@",error);
        }
        self->_inboxList = inboxList;
        self->_allItemContentArray = [[NSMutableArray alloc] init];
        [self getItemContentRecursion:0];
    }];
    
}

    ///获取前10条数据
-(void)getItemContentRecursion:(int)index{
    if (index<10) {//_inboxList.count
//        [[[EWSItemContent alloc] init] sendEmail:ewsEmailBoxModel.mailServerAddress finishBlock:^(EWSItemContentModel *itemContentInfo, NSError *error) {
//            NSLog(@"error??");
//        }];
//        return;
        [[[EWSItemContent alloc] init] getItemContentWithEWSUrl:ewsEmailBoxModel.mailServerAddress item:_inboxList[index] finishBlock:^(EWSItemContentModel *itemContentInfo, NSError *error) {
            if (error) {
                self->_error = error;
            }
            else{
                self->_error = nil;
            }
            
            [self->_allItemContentArray addObject:itemContentInfo];
            [self getItemContentRecursion:index+1];
        }];
    }
    else{
        if (_managerGetAllItemContentBlock) {
            
            _managerGetAllItemContentBlock([_allItemContentArray copy], _error);
            
            [_allItemContentArray removeAllObjects];
            _allItemContentArray = nil;
        }
    }
}

-(void)getMailAllAttachmentWithItemContentInfo:(EWSItemContentModel *)itemContentInfo complete:(void (^)())managerGetAllAttachmentCompleteBlock{
    _managerGetAllAttachmentCompleteBlock = managerGetAllAttachmentCompleteBlock;
    [self getMailAttachmentRecursion:itemContentInfo index:0];
}

-(void)getMailAttachmentRecursion:(EWSItemContentModel *)itemContentInfo index:(int)i {
    [[[EWSMailAttachment alloc] init] getAttachmentWithEWSUrl:ewsEmailBoxModel.mailServerAddress attachmentInfo:itemContentInfo.attachmentList[i] complete:^{
        if (i==itemContentInfo.attachmentList.count-1) {
            if (self->_managerGetAllAttachmentCompleteBlock) {
                self->_managerGetAllAttachmentCompleteBlock();
            }
        }
        else{
            [self getMailAttachmentRecursion:itemContentInfo index:i+1];
        }
    }];
}

-(void)getMailAttachmentWithAttachmentModel:(EWSMailAttachmentModel *)attachmentModel complete:(void (^)())managerGetAttachmentCompleteBlock{
    _managerGetAttachmentCompleteBlock = managerGetAttachmentCompleteBlock;
    [[[EWSMailAttachment alloc] init] getAttachmentWithEWSUrl:ewsEmailBoxModel.mailServerAddress attachmentInfo:attachmentModel complete:^{
        if (self->_managerGetAttachmentCompleteBlock) {
            self->_managerGetAttachmentCompleteBlock();
        }
    }];
}

@end
