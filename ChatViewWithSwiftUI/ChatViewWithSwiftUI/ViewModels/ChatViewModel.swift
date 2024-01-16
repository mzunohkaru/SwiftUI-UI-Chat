//
//  ChatViewModel.swift
//  ChatViewWithSwiftUI
//
//  Created by Mizuno Hikaru on 2024/01/10.
//

import Foundation

class ChatViewModel: ObservableObject {
    
    @Published var chatData: [Chat] = []
    
    init() {
        chatData = fetchChatData()
    }
    
    // Json Dataを変換する関数
    // -> [Chat] : 戻り値は、Chatモデルのインスタンスを要素に持つ配列
    private func fetchChatData() -> [Chat] {
        // インポートしたJsonファイルの名前
        let fileName = "chatData.json"
        // データを格納するためのData型の定数
        let data: Data
        
        // fileNameのPathを取得
        guard let filePath = Bundle.main.url(forResource: fileName, withExtension: nil)
        else {
            // nil が返ってきた場合
            fatalError("Not Found \(fileName)")
        }
        
        do {
            // filePathからデータを取得
            // try : 例外処理
            data = try Data(contentsOf: filePath)
        }
        catch {
            fatalError("Fail Load \(fileName)")
        }
        
        do {
            // dataをJson形式から、Swiftで使える形式に変換
            // Json形式から、[Chat].self構造のデータに変換させる
            return try JSONDecoder().decode([Chat].self, from: data)
        }
        catch {
            fatalError("Failure to convert \(fileName) to \(Chat.self)")
        }
    }
    
    func addMessage(chatId: String, text: String) {
        // firstIndex : 配列 (chatData) の要素の中で、特定の条件がtrueになる要素のindexを返す
        guard let index = chatData.firstIndex(where: { chat in
            chat.id == chatId
        }) else { return }
        
        /// Date().description -> 2023-01-20 11:22:33 +0000
        /// フォーマットが  yyy-MM-dd HH:mm:ss  なので、整形をする
        let formatter = DateFormatter()
        // 入力するフォーマット
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let formattedDateString = formatter.string(from: Date())
        
        let newMessage = Message(
            id: UUID().uuidString,
            text: text,
            user: User.currentUser,
            date: formattedDateString,
            readed: false
        )
        
        chatData[index].messages.append(newMessage)
    }
    
    func getTitle(messages: [Message]) -> String {
        var title = ""
        
        let names = getMembers(messages: messages, type: .name)
        
        for name in names {
            title += title.isEmpty ? "\(name)" : ", \(name)"
        }
        
        return title
    }
    
    func getImages(messages: [Message]) -> [String] {  getMembers(messages: messages, type: .image)  }
    
    func getMembers(messages: [Message], type: ValueType) -> [String] {
        var members: [String] = []
        var userIds: [String] = []
        
        for message in messages {
            
            let id = message.user.id
            
            // idが現在ログインしているユーザーの場合、continue (次のFor文に回す)
            if id == User.currentUser.id ||
                // userIds配列に既にidが存在する場合、continue (次のFor文に回す)
                userIds.contains(id) { continue }
            
            userIds.append(id)
            
            switch type {
            case .name:
                members.append(message.user.name)
            case .image:
                members.append(message.user.image)
            }
        }
        return members
    }
}

enum ValueType {
    case name
    case image
}
