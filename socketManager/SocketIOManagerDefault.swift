//
//  SocketIOManagerDefault.swift
//  ChatApp
//
//  Created by Ramananda on 5/3/23.
//

import Foundation
import SocketIO


class SocketIOManagerDefault : NSObject, SocketIOManager {
   
    
    
    //MARK: - Instance Properties
     
     private var manager: SocketManager!
     private var socket: SocketIOClient!
     
     //MARK: - Initializers
     
     override init() {
         super.init()
        manager  = SocketManager(socketURL:  URL(string:AppUrl.socketURL)!, config: [.log(true), .forceNew(true), .reconnectAttempts(10), .reconnectWait(6000), .connectParams(["userId" : "+8801738039685", "userToken" : "ecwe-kffR9K0PCe70rvDDo:APA91bG8W6XrWUw_rUi3JbWYtzt9F236oFuOq4nXJBVGHKIVybmoDJKZbYgJ3RO_i-BDY8L6aAzoEzaOX_20diEOENn3SFZCRQOI6tTWw3cAW59FXs3vcrshn1wOIali6dCkPk7duhK0"]), .forceWebsockets(true), .compress])
         
         //manager = SocketManager(socketURL: URL(string: "http://10.17.33.93:3000")!)
         socket = manager.defaultSocket
         
         establishConnection()
     }
     
     //MARK: - Instance Methods
     
     func establishConnection() {
         socket.connect()
     }
     
     func closeConnection() {
         socket.disconnect()
     }
     
     func connectToChat(with name: String) {
         socket.emit("connectUser", name)
     }
     
     func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void) {
         socket.on("userList") { dataArray, _ in
             completionHandler(dataArray[0] as! [[String: Any]])
         }
     }
     
     func send(message: String, username: String) {
         socket.emit("chatMessage", username, message)
     }
     
     func observeMessages(completionHandler: @escaping ([String: Any]) -> Void) {
         socket.on("newChatMessage") { dataArray, _ in
             var messageDict: [String: Any] = [:]
             
             messageDict["nickname"] = dataArray[0] as! String
             messageDict["message"] = dataArray[1] as! String
             
             completionHandler(messageDict)
         }
     }
    
    
    func sendMessage(message: String) {
        
        let messageDict: [String: Any] = [
            "api_token": "L4KX8hcEmXNTK3vIi1I4fQZR8HGlOTbtgAwCf1UDElsHmj3KyPyqA2ssFn1C",
            "room": "orko6-13",
            "msg": message,
            "doctor_id": "13",
            "chat_type": "text",
            "user_id": "+8801738039685",
            "receiver_id": "+8801401155116",
            "sender_name": "Stay home",
            "sender_image": "/storage/images/profile/Orko-Pro-Dev_2022_11_14_00_50_30-Nov-14th-22-12-50-39.jpg",
            "created_at": Date().currentTimeFormat,
            "created_date": Date().currentDateFormat,
            "is_group": false,
            "is_delivered": false,
            "is_seen": false
        ]
        
        print(messageDict)
        socket.emit("chat_message", messageDict)
    }
    
    
    
}
