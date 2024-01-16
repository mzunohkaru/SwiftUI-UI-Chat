//
//  User.swift
//  ChatViewWithSwiftUI
//
//  Created by Mizuno Hikaru on 2024/01/10.
//

import Foundation

struct User: Decodable {
    let id: String
    let name: String
    let image: String
    
    // 計算プロパティ
    var isCurrentUser: Bool {
        self.id == User.currentUser.id
    }
    
    // static: プロジェクト全体で共通の値にする
    static var currentUser: User {
        User(id: "1", name: "Hikaru", image: "user01")
    }
}
