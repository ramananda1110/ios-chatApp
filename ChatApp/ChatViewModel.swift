//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Ramananda on 25/2/23.
//

import Foundation
import SocketIO

class ChatsViewModel: ObservableObject {
    
    @Published var chats = Chat.sampleChat
    
    private var socketManager = Managers.socketManager

//    let manager = SocketManager(socketURL: URL(string: AppUrl.socketURL)!,  config: [.log(true), .compress], .connectParams(["user_id" : "+8801401155116", "userToken" : ""]))
//
    
  let  manager  = SocketManager(socketURL:  URL(string:AppUrl.socketURL)!, config: [.log(true), .forceNew(true), .reconnectAttempts(10), .reconnectWait(6000), .connectParams(["userId" : "+8801738039685", "userToken" : "ecwe-kffR9K0PCe70rvDDo:APA91bG8W6XrWUw_rUi3JbWYtzt9F236oFuOq4nXJBVGHKIVybmoDJKZbYgJ3RO_i-BDY8L6aAzoEzaOX_20diEOENn3SFZCRQOI6tTWw3cAW59FXs3vcrshn1wOIali6dCkPk7duhK0"]), .forceWebsockets(true), .compress])
   
    //let socket = manager.defaultSocket
    
    var socket: SocketIOClient!
        @Published var messageText = ""
        @Published var messages = [ChatMessage]()

    
    func connect() {
           socket = manager.defaultSocket
           socket.on("connect") { _, _ in
               print("Connected")
           }

           socket.on("get_message") { data, _ in
               if let messageDict = data[0] as? [String: Any], let message = ChatMessage(dictionary: messageDict) {
                   DispatchQueue.main.async {
                       self.messages.append(message)
                   }
               }
           }

           socket.connect()
       }
    
    
    func sendMessage() {
        
        //socket = manager.defaultSocket
        // socket.connect()
        
        //guard let  username = message?.isEmpty else {
        //  return
        //  }
        
        //            let messageDict: [String: Any] = [
        //                "api_token": "L4KX8hcEmXNTK3vIi1I4fQZR8HGlOTbtgAwCf1UDElsHmj3KyPyqA2ssFn1C",
        //                "room": "orko6-13",
        //                "msg": messageText,
        //                "doctor_id": "13",
        //                "chat_type": "text",
        //                "user_id": "+8801738039685",
        //                "receiver_id": "+8801401155116",
        //                "sender_name": "Stay home",
        //                "sender_image": "/storage/images/profile/Orko-Pro-Dev_2022_11_14_00_50_30-Nov-14th-22-12-50-39.jpg",
        //                "create_at": Date().currentTimeFormat,
        //                "created_date": Date().currentDateFormat,
        //                "is_group": false,
        //                "is_delivered": false,
        //                "is_seen": false
        //            ]
        //
        //            print(messageDict)
        //            socket.emit("chat_message", messageDict)
        
        //sendMessage(messageText, in: chats[0])
        socketManager.sendMessage(message: messageText)
        messageText = ""
    }
    
    func sentSocketMessage(msg: String) {
        socketManager.sendMessage(message: msg)
    }

    
    func getSortedFilteredChats(query :String) -> [Chat] {
        
        let sortedChat = chats.sorted{
            guard let date1 = $0.messages.last?.date else {return false}
            guard let date2 = $1.messages.last?.date else {return false}
            
            return date1 > date2
        }
        
        if query == "" {
            return sortedChat
        }
        
        return sortedChat.filter{ $0.person.name.lowercased().contains(query.lowercased())}
    }
    
    
    func getSelectionMessage(for chat: Chat) -> [[Message]] {
        var res = [[Message]] ()
        var tmp = [Message]()
        
        for message in chat.messages {
            if let firstMessage = tmp.first {
                let daysBetween = firstMessage.date.daysBetween(date: message.date)
                
                if daysBetween >= 1 {
                    res.append(tmp)
                    tmp.removeAll()
                    tmp.append(message)
                }else {
                    tmp.append(message)
                }
            } else {
                tmp.append(message)
            }
        }
        
        res.append(tmp)
        
        return res
    }
    
    
    func markAsUnread(_ newValue:Bool,  chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].hasUnreadMessage = newValue
        }
    }
    
    func sendMessage(_ text:String, in chat: Chat) -> Message? {
        if let index = chats.firstIndex(where: { $0.id == chat.id }){
            let message = Message(text, type: .Sent)
            chats[index].messages.append(message)
            
            return message
            
        }
        return nil
    }
    
    
    
    
    
    
    
}


struct ChatMessage: Identifiable {
    let id: UUID
    let username: String
    let text: String

    init?(dictionary: [String: Any]) {
        guard let username = dictionary["username"] as? String,
            let text = dictionary["text"] as? String else {
                return nil
        }

        self.id = UUID()
        self.username = username
        self.text = text
    }
}
