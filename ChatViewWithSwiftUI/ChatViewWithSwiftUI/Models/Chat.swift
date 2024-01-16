//
//  Chat.swift
//  ChatViewWithSwiftUI
//
//  Created by Mizuno Hikaru on 2024/01/10.
//

import Foundation

// Decodable : JSONDecoderを使用するため
// Identifiable : Message型のインスタンスの値がユニークになることを保証する
struct Chat: Decodable, Identifiable {
    let id: String
    var messages: [Message]
    
    // messages配列の最後の要素のtextを取得するプロパティ
    var recentMessageText: String {
        // recentMessageがオプショナル型(Message?)になるから、guard letでアンラップする
        guard let recentMessage = self.messages.last else { return "" }
        
        return recentMessage.text
    }
    
    var recentMessageDateString: String {
        guard let recentMessage = self.messages.last else { return "" }
        
        let formatter = DateFormatter()
        // 入力するフォーマット
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: recentMessage.date) else { return "" }
        // 出力するフォーマット
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}
