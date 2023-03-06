//
//  ChatRow.swift
//  ChatApp
//
//  Created by Ramananda on 25/2/23.
//

import SwiftUI

struct ChatRow: View {
    
    let chat: Chat
    
    var body: some View {
        
        HStack(spacing: 20){
            Image(systemName: chat.person.imgString).resizable().frame(width: 40, height: 40).clipShape(Circle())
            
            ZStack {
                VStack(alignment: .leading, spacing: 5){
                    HStack {
                        Text(chat.person.name).bold()
                        
                        Spacer()
                        
                        Text(chat.messages.last?.date.descriptiveString() ?? "")
                    }
                    
                    HStack {
                        Text(chat.messages.last?.text ?? "")
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .frame(height: 40, alignment: .top)
                    }
                }
                
                Circle()
                    .foregroundColor(chat.hasUnreadMessage ? .blue : .clear)
                    .frame(width: 18, height: 18)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat: Chat.sampleChat[0])
    }
}
