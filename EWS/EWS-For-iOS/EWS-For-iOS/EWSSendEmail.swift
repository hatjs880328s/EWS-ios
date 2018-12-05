//
//  EWSSendEmail.swift
//  EWS-For-iOS
//
//  Created by Noah_Shan on 2018/12/5.
//  Copyright © 2018 wangxk. All rights reserved.
//

import Foundation


class EWSSendEmail: NSObject {
    override init() {
        super.init()
    }

    @objc func sendEmailBodyXML()->String {
        let xml = """
<?xml version="1.0" encoding="utf-8"?>
     <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xmlns:m="http://schemas.microsoft.com/exchange/services/2006/messages"
     xmlns:t="http://schemas.microsoft.com/exchange/services/2006/types"
     xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
     <soap:Body>
     <m:CreateItem MessageDisposition="SendAndSaveCopy">
     <m:SavedItemFolderId>
     <t:DistinguishedFolderId Id="sentitems" />
     </m:SavedItemFolderId>
     <m:Items>
     <t:Message>
     <t:Subject>Company Soccer Team</t:Subject>
     <t:Body BodyType="HTML">From ios exchange...</t:Body>
     <t:ToRecipients>
     <t:Mailbox>
     <t:EmailAddress>451145552@qq.com </t:EmailAddress>
     </t:Mailbox>
     </t:ToRecipients>
     </t:Message>
     </m:Items>
     </m:CreateItem>
     </soap:Body>
     </soap:Envelope>
"""
        return xml
    }
}
