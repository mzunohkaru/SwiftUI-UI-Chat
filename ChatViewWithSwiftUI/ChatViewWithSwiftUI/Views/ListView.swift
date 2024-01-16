//
//  ListView.swift
//  ChatViewWithSwiftUI
//
//  Created by Mizuno Hikaru on 2024/01/10.
//


import SwiftUI

struct ListView: View {
    
    @ObservedObject var vm: ChatViewModel = ChatViewModel()
    
    var body: some View {
        NavigationView() {
            VStack {
                // Header
                header
                
                // List
                list
            }
            .padding(.horizontal)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

extension ListView {
    
    private var header: some View {
        HStack {
            Text("トーク")
                .font(.title2.bold())
            
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: "text.badge.checkmark")
                Image(systemName: "square")
                Image(systemName: "ellipsis.bubble")
            }
            .font(.title2)
        }
    }
    
    private var list: some View {
        ScrollView {
            VStack {
                ForEach(vm.chatData) { chat in
                    NavigationLink {
                        ChatView(chat: chat)
                            .environmentObject(vm)
                            //画面遷移するとデフォルトで配置されるBackボタンを非表示にする
                            .toolbar(.hidden)
                    } label: {
                        listRow(chat: chat)
                    }
                }
            }
        }
    }
    
    //メソッド化
    private func listRow(chat: Chat) -> some View {
    //private var listRow: some View {
        HStack {
            // chat.messages -> [Message]
            let images = vm.getImages(messages: chat.messages)
            
            // spacing をマイナス値に設定すると、モディファイアが重なり合う
            HStack(spacing: -28){
                // ForEachの第1引数がString型のコレクション (images) の場合は、idに配列そのものを設定できる
                ForEach(images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .foregroundColor(Color(uiColor: .systemBackground))
                                .frame(width: 54, height: 54)
                        }
                }
            }
            
            VStack(alignment: .leading) {
                // chat.messages -> [Message]
                Text(vm.getTitle(messages: chat.messages))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                //最後のメッセージ
                Text(chat.recentMessageText)
                    .font(.footnote)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .lineLimit(1)
            }
            Spacer()
            Text(chat.recentMessageDateString)
                .font(.caption)
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }
}
