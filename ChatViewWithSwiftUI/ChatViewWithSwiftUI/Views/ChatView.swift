//
//  ChatView.swift
//  ChatViewWithSwiftUI
//
//  Created by Mizuno Hikaru on 2024/01/09.
//

import SwiftUI

struct ChatView: View {
    
    let chat: Chat
    
    @State private var textFieldText: String = ""
    // @FocusState : Focusの状態を監視したい要素に関連付けできる
    @FocusState private var textFieldFocused: Bool
    // 画面を閉じるためのハンドラーの取得
    @Environment(\.dismiss) private var dismiss
    
    //ChatViewModelインスタンスをプロジェクトの中で統一する
    @EnvironmentObject var vm: ChatViewModel
    // @ObservedObject var vm: ChatViewModel = ChatViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Messagee Area
            messageArea
            // Navigation Area
                .overlay(
                    navigationArea
                    , alignment: .top
                )
            // Input Area
            inputArea
        }
    }
}

//プロパティ・メソッドの分離
extension ChatView {
    // some : 型の抽象化
    private var messageArea: some View{
        // proxyを使用し、子要素のScrollViewをコントロールする
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    // ForEachに配列などのコレクションタイプを指定する場合は、idプロパティの宣言も必要
                    // \.id、この \ は、メモリへの参照を指定する
                    //                ForEach(vm.messages, id: \.id) { _ in
                    // 構造体 Message に Identifiable プロトコルを追加した場合、idプロパティの宣言は不必要
                    ForEach(chat.messages) { message in
                        MessageRow(message: message)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 72)
            }
            // AssetsフォルダーのColor SetのColor<Background
            .background(Color("Backgroud"))
            .onTapGesture {
                textFieldFocused = false
            }
            // モディファイアが描画される寸前に呼ばれる
            .onAppear {
                scrollToLast(proxy: proxy)
            }
        }
    }
    
    private var inputArea: some View{
        HStack {
            HStack(spacing: 16){
                Image(systemName: "plus")
                Image(systemName: "camera")
                Image(systemName: "photo")
            }
            .font(.title2)
            TextField("Aa", text: $textFieldText)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(Capsule())
                .overlay (
                    Image(systemName: "face.smiling")
                        .font(.title2)
                        .padding(.trailing)
                        .foregroundColor(.gray)
                    
                    , alignment: .trailing
                )
                .onSubmit {
                    sendMessage()
                }
                .focused($textFieldFocused)
            Image(systemName: "mic")
                .font(.title2)
        }
        .padding()
        // DarkTheme対応
        .background(Color(uiColor: .systemBackground))
    }
    
    private var navigationArea: some View{
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            Text(vm.getTitle(messages: chat.messages))
                .font(.title2.bold())
                .lineLimit(1)
            Spacer()
            HStack(spacing: 16){
                Image(systemName: "text.magnifyingglass")
                Image(systemName: "phone")
                Image(systemName: "line.3.horizontal")
            }
            .font(.title2)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color("Backgroud").opacity(0.9))
    }
    
    private func sendMessage() {
        if !textFieldText.isEmpty{
            vm.addMessage(chatId: chat.id, text: textFieldText)
            textFieldText = ""
        }
    }
    
    private func scrollToLast(proxy: ScrollViewProxy) {
        // lastMessageは、Message? (オプショナル型) なので、if letでアンラップする
        // messages配列に格納された最後の要素を取得
        if let lastMessage = chat.messages.last {
            // anchor : 画面の中のどの位置に第1引数(lastMessage.id)のスクロール位置を配置するか指定する
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}
