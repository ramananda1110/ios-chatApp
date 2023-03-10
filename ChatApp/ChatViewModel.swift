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


    @Published var messageText = ""
    @Published var messages = [MessageData]()


    
    init(chats: [Chat] = Chat.sampleChat, socketManager: SocketIOManager = Managers.socketManager, messageText: String = "", messages: [MessageData] = [MessageData]()) {
        self.chats = chats
        self.socketManager = socketManager
        self.messageText = messageText
        self.messages = messages
        
        socketManager.establishConnection()
        
        getMessage(chats: chats[0])
    }
    
    
    func receiveMessage(completionHandler: @escaping ([String: Any]) -> Void) {
        socketManager.getSocketInstance().on("get_message") { dataArray, _ in
            var messageDict: [String: Any] = [:]
            
            messageDict["sender_image"] = dataArray[0] as! String
            messageDict["msg"] = dataArray[0] as! String
           // let json:JSON = JSON(data[0])//JSON.init(parseJSON: cur)
            completionHandler(messageDict)
        }
    }
   
   
    
    func sendMessage() {
        
        let messageDict: [String: Any] = [
                        "api_token": "L4KX8hcEmXNTK3vIi1I4fQZR8HGlOTbtgAwCf1UDElsHmj3KyPyqA2ssFn1C",
                        "room": "orko6-13",
                        "msg": messageText,
                        "doctor_id": "13",
                        "chat_type": "text",
                        "user_id": "+8801738039685",
                        "receiver_id": "+8801401155116",
                        "sender_name": "Stay home",
                        "sender_image": "/storage/images/profile/Orko-Pro-Dev_2022_11_14_00_50_30-Nov-14th-22-12-50-39.jpg",
                        "create_at": Date().currentTimeFormat,
                        "created_date": Date().currentDateFormat,
                        "is_group": false,
                        "is_delivered": false,
                        "is_seen": false
                    ]
        
        socketManager.getSocketInstance().emit("chat_message", messageDict)
                    print(messageDict)
        
        self.messageText = ""
    }
    
    func getMessage(chats: Chat) {
        socketManager.getSocketInstance().on("get_message") { data, _ in
            
            print("message--------------print--1")
            
            //  let message: MessageData = try JSONDecoder().decode(MessageData.self, from: data[0])
            
            // receivedMessage(text: "helll", in: chat)
            
            do {
                let dat = try JSONSerialization.data(withJSONObject:data[0])
                let res = try JSONDecoder().decode(MessageData2.self,from:dat)
                
                self.receivedMessage(res.msg, in: chats)
                print("message--------------final ")
               
                print(res)
            }
            catch {
                print(error)
            }
        }
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
    
    func receivedMessage(_ text:String, in chat: Chat) -> Message? {
        
        if let index = chats.firstIndex(where: { $0.id == chat.id }){
            let message = Message(text, type: .Received)
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

struct MessageData2: Codable {
    
   // let chatId : UUID
    
    let id: Int
    let type: String
    
//    let message_id: String
    let user_id: String
    let sender_id: Int
   // let group_id: Int
    let room: String
    let sender_name: String
    let sender_image: String
   // let sender_description: String
//    let sender_degree: String
    
    let is_doctor: Int
    let msg: String
    let created_date: String
    let created_at: String
    let chat_type: String
    let deliver_status: Int
    let is_deleted: Bool
//    let additional_note: String
    
    
    
}


struct MessageData: Identifiable {
    
   // let chatId : UUID
    
    let id: Int
    let type: String
    
    let messageId: String
    let userId: String
    let senderId: Int
    let group_id: Int
    let room: String
    let senderName: String
    let senderImg: String
    let sender_description: String
    let sender_degree: String
    
    let is_doctor: Int
    let msg: String
    let created_date: String
    let created_at: String
    let chat_type: String
    let deliver_status: Int
    let is_deleted: Bool
    let additional_note: String
    
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let type = dictionary["type"] as? String,
            let messageId = dictionary["message_id"] as? String,
            let userId = dictionary["user_id"] as? String,
            let senderId = dictionary["sender_id"] as? Int,
            let groupId = dictionary["group_id"] as? Int,
            let room = dictionary["room"] as? String,
            let senderName = dictionary["sender_name"] as? String,
            let senderImg = dictionary["sender_image"] as? String,
            let senderDes = dictionary["sender_description"] as? String,
            let senderDegree = dictionary["sender_degree"] as? String,
            let isDoctor = dictionary["is_doctor"] as? Int,
            let created_date = dictionary["created_date"] as? String,
            let created_at = dictionary["created_at"] as? String,
            let chat_type = dictionary["chat_type"] as? String,
            let deliveryStatus = dictionary["deliver_status"] as? Int,
            let is_deleted = dictionary["is_deleted"] as? Bool,
            let additional_note = dictionary["additional_note"] as? String,
            
                let msg = dictionary["msg"] as? String else {
                return nil
        }

       // self.chatId = UUID()
        self.id = id
        self.msg = msg
        self.type = type
        self.messageId = messageId
        self.userId = userId
        self.senderId = senderId
        self.group_id = groupId
        self.room = room
        self.senderName = senderName
        self.senderImg = senderImg
        self.sender_degree = senderDegree
        self.sender_description = senderDes
        self.is_doctor = isDoctor
        self.created_date = created_date
        self.created_at = created_at
        self.chat_type = chat_type
        self.deliver_status = deliveryStatus
        self.is_deleted = is_deleted
        self.additional_note = additional_note
        
    }
}
