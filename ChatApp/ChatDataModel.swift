//
//  ChatDataModel.swift
//  ChatApp
//
//  Created by Ramananda on 6/3/23.
//

import Foundation


struct ChatResponse : Identifiable {
    var id = UUID()
    var data: [MessageData]
    var message: String
    var status_code: Int
}

