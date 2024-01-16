//
//  Message.swift
//  ChatViewWithSwiftUI
//
//  Created by Mizuno Hikaru on 2024/01/10.
//

import Foundation

// Identifiable : Message型のインスタンスの値がユニークになることを保証する
struct Message: Decodable, Identifiable {
//    let id: String = UUID().uuidString
    let id: String
    let text: String
    let user: User
    let date: String
    let readed: Bool
}
