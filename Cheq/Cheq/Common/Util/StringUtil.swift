//
//  StringUtil.swift
//  Cheq
//
//  Created by XUWEI LIANG on 19/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class StringUtil {
    static let shared = StringUtil()
    private init() {}

    func decodeBase64(_ base64Encoded: String)-> String {
        guard let decodedData = Data(base64Encoded: base64Encoded) else { return "" }
        return String(data: decodedData, encoding: .utf8) ?? ""
    }
}
