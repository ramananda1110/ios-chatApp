//
//  SocketIOManager.swift
//  ChatApp
//
//  Created by Ramananda on 5/3/23.
//

import Foundation

import SocketIO

protocol SocketIOManager {
    
    func establishConnection()
    func closeConnection()
    func connectToChat(with name: String)
    func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void)
    func send(message: String, username: String)
    func sendMessage(message: String)
    func observeMessages(completionHandler: @escaping ([String: Any]) -> Void)
    
    func getSocketInstance() -> SocketIOClient
}
