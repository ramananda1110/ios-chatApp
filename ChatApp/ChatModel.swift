//
//  ChatModel.swift
//  ChatApp
//
//  Created by Ramananda on 25/2/23.
//

import Foundation


struct Chat : Identifiable {
    var id: UUID { person.id }
    let person : Person
    var messages: [Message]
    var hasUnreadMessage = false
}


struct Person: Identifiable {
    let id = UUID()
    let name: String
    let imgString: String
}


struct Message: Identifiable {
    enum MessageType {
        case Sent, Received
    }
    
    let id = UUID()
    let date: Date
    let text: String
    let type: MessageType
    
    init(_ text: String, type: MessageType, date: Date) {
        self.date = date
        self.type = type
        self.text = text
    }
    
    init(_ text: String, type: MessageType) {
        self.init(text, type: type, date: Date())
    }
}


extension Chat {
    static let sampleChat = [
    
        Chat(person: Person(name: "Adri sarkar", imgString: "person"), messages: [
            Message("Ggy", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Keep your shoulders wown and back", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
            Message("sleep well", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 1)),
            Message("don't exercise while sleeping", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("sleeping well", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("What do you call a fish with no eyes?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1))
                ], hasUnreadMessage: true
            ),
        
        Chat(person: Person(name: "rezwan hoque", imgString: "person.2.circle"), messages: [
            Message("Hey putin", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("this is new message for to you , can you help me out with it?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
            Message("Please I need your help ", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1)),
            Message("Sure how can i help you flo?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("Sure I can do that, no problem?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("What do you call a fish with no eyes?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1))
                ], hasUnreadMessage: false
            ),
        
        Chat(person: Person(name: "Sajjad Alam", imgString: "person.2.fill"), messages: [
            Message("Twstt", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Gjag", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 2)),
            Message("Test message", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 1)),
            Message("Ok", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("Let's connection on Krko", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("High", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 1))
                ], hasUnreadMessage: false
            ),
        
        Chat(person: Person(name: "Ramananda Sarkar", imgString: "person.2.fill"), messages: [
            Message("Hi", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Hello", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
            Message("Hi", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1)),
            Message("GHu", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("Hello", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("I'll call you giht later", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1))
                ], hasUnreadMessage: false
            ),
        
        Chat(person: Person(name: "Zunayed Arifin", imgString: "person.2.fill"), messages: [
            Message("Hey modi", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("currect app your plane rd to crate a fake chat conversation , can you help me out with it?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
            Message("Please I need your help ", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1)),
            Message("How are you?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("Sure I can do that, no problem?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)),
            Message("Hello?", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1))
                ], hasUnreadMessage: false
            )
    ]
}
