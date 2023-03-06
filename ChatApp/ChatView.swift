//
//  ChatView.swift
//  ChatApp
//
//  Created by Ramananda on 25/2/23.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var viewModel : ChatsViewModel
    //@StateObject var viewModel = ChatViewModel

    @State  private var messageIDToScroll: UUID?
    
    let chat : Chat
   
    @State private var text = ""
    @FocusState private var isFocused
    
 
    
    var body: some View {
        
        VStack(spacing: 0) {
            GeometryReader {
                reader in ScrollView {
                    ScrollViewReader {
                        scrollReader in   getMessageView(viewWidth: reader.size.width)
                            .padding(.horizontal)
                            .onChange(of: messageIDToScroll) {
                                _ in if let messageID = messageIDToScroll {
                                    scrollTo(messageId: messageID, shouldAnimate: true, scrollReader: scrollReader)
                                }
                            }
                            .onAppear{
                                if let messageID = chat.messages.last?.id {
                                    scrollTo(messageId: messageID, shouldAnimate: true, scrollReader: scrollReader)

                                }
                            }

                    }
                }
            }
//            .background(Color.yellow)
            .padding(.bottom, 5)
            
            toolbarView()
            
        }.padding(.top, 1)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: navBarLeadingImgBtn, trailing: navBarTrailingBtn)
            .onAppear{
                viewModel.markAsUnread(false, chat: chat)
            }
    }
    
    
    var navBarLeadingImgBtn : some View {
        Button(action: {}){
            HStack {
                Image(systemName: chat.person.imgString).resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text(chat.person.name).bold()
            }.foregroundColor(.blue)
        }
    }
    
    var navBarTrailingBtn: some View {
        HStack {
            Button(action: {}){
               Image(systemName: "video")
            }
            Button(action: {}){
               Image(systemName: "phone")
            }
        }
    }
    
    
    func toolbarView() ->  some View {
        VStack {
            let height : CGFloat = 37
            HStack {
               
                TextField("Message...", text: $text)
                    .padding(.horizontal, 10)
                    .frame(height: height)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .focused($isFocused)
                
                Button(action: sendMessage){
                    Image(systemName: "paperplane.fill").foregroundColor(.white)
                        .frame(width: height, height: height)
                        .background(Circle().foregroundColor(viewModel.messageText.isEmpty ? .gray : .blue))
                }
                .disabled(text.isEmpty)
            }.frame(height: height)
        }.padding(.vertical)
            .padding(.horizontal).background(.thickMaterial)
    }
    
    func sendMessage() {
        
        //viewModel.sendMessage()
        
        if let message = viewModel.sendMessage(text, in: chat){
            //text = ""
            messageIDToScroll = message.id
        }

        
        viewModel.sentSocketMessage(msg: text)
        
        text = ""
       
    }
    
    
    func scrollTo(messageId: UUID, anchor: UnitPoint? = nil, shouldAnimate: Bool,
                  scrollReader : ScrollViewProxy){
        DispatchQueue.main.async {
            withAnimation(shouldAnimate ? Animation.easeIn : nil) {
                scrollReader.scrollTo(messageId, anchor: anchor)
            }
        }
    }
   
    let columns = [GridItem(.flexible(minimum: 10))]

    func getMessageView(viewWidth: CGFloat) -> some View {
       
        LazyVGrid(columns: columns, spacing: 0, pinnedViews: [.sectionHeaders]) {
            
            let selectionMessage = viewModel.getSelectionMessage(for: chat)
            ForEach(selectionMessage.indices, id: \.self) { selectionIndex in
                
                let messages = selectionMessage[selectionIndex]
                
                Section(header: sectionHeader(firstMessage: messages.first!)) {
                    
                    ForEach(messages) {message in
                        let isReceived = message.type == .Received
                        
                        HStack {
                            ZStack {
                                Text(message.text)
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                    .background( isReceived ? Color.black.opacity(0.2) : .green.opacity(0.9))
                                    .cornerRadius(14)
                            }.frame(width: viewWidth * 0.7, alignment: isReceived ? .leading : .trailing)
                                .padding(.vertical)
                            //                        .background(Color.blue)
                        }.frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
                    }
                }
                
                
            }
        
            
        }
    }

    
    func sectionHeader(firstMessage message: Message) -> some View {
        ZStack {
            Text(message.date.descriptiveString(dateStyle: .medium))
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .regular))
                .frame(width: 120)
                .padding(.vertical, 5)
                .background(Capsule().foregroundColor(.blue))
        }.padding(.vertical, 5)
            .frame(width: .infinity)
    }
    
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            
            ChatView(chat: Chat.sampleChat[0])
        }
    }
}
