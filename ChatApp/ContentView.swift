//
//  ContentView.swift
//  ChatApp
//
//  Created by Ramananda on 25/2/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
   // let chats = Chat.sampleChat
    @State private var query = ""
    
    @StateObject var viewModel = ChatsViewModel()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(viewModel.getSortedFilteredChats(query: query)){chat in
                    
                    ZStack {
                        ChatRow(chat: chat)
                        NavigationLink(destination: {
                            ChatView(chat: chat).environmentObject(viewModel)
                        }) {
                            EmptyView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 0)
                        .opacity(0)
                    }.swipeActions(edge: .leading, allowsFullSwipe: true){
                        Button(action: {
                            viewModel.markAsUnread(true, chat: chat)
                        }){
                            if chat.hasUnreadMessage {
                                Label("Read", systemImage: "text.bubble")
                            } else {
                                Label("Unread", systemImage: "text.fill")
                            }
                        }.tint(.blue)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $query)
            .navigationTitle("Chat")
            .navigationBarItems(trailing: Button(action: {}){
                Image(systemName: "square.and.pencil")
            })
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
