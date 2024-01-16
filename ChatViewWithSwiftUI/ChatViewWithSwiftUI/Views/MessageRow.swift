//
//  MessageRow.swift
//  ChatViewWithSwiftUI
//
//  Created by Mizuno Hikaru on 2024/01/10.
//

import SwiftUI

struct MessageRow: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top) {
            if message.user.isCurrentUser {
                
                Spacer()
                messageState
                messageText
                
            } else {
                
                userThumb
                messageText
                messageState
                Spacer()
                
            }
        }
        .padding(.bottom)
    }
}


extension MessageRow{
    private var userThumb: some View{
        Image(message.user.image)
            .resizable()
            .frame(width: 48, height: 48)
            .clipShape(Circle())
    }
    
    private var messageText: some View{
        Text(message.text)
            .padding()
            .background(message.user.isCurrentUser ? Color("Bubble") : Color(uiColor: .tertiarySystemBackground))
            .foregroundColor(message.user.isCurrentUser ? .black : .primary)
            .cornerRadius(30)
    }
    
    private var messageState: some View{
        VStack(alignment: .trailing) {
            Spacer()
            if message.user.isCurrentUser && message.readed {
                Text("read")
            }
            //現在の日時
            Text(formattedDataString)
        }
        .foregroundColor(.secondary)
        .font(.footnote)
    }
    
    //現在の日時
    private var formattedDataString: String{
        let formatter = DateFormatter()
        
//        formatter.timeStyle = .short
//        return formatter.string(from: Date())
        
        // 入力するフォーマット
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: message.date) else { return "" }
        // 出力するフォーマット
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
