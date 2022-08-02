//
//  ETCDetialContentView.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/8/2.
//

import SwiftUI
import TextSourceful

struct ETCDDetiaContentTextView: View {
    @State var text:String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("值")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .opacity(0.75)
                    .padding(.leading,20)
                    .frame(alignment: .leading)
                Spacer()
                Button {
                    
                } label: {
                    Text("粘贴")
                        .font(.caption)
                        .foregroundColor(Color(hex:"#00FFFF"))
                        .padding(8)
                        .frame(height: 25)
                }.background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                Text("")
                    .frame(width: 10)
            }
            Divider().frame(height:0.5)
            HStack{
                TextSourceCodeTextEditor(text: $text)
                    .lineLimit(nil)
                    .foregroundColor(.secondary)
                    .font(.system(size: 12))
                    .lineSpacing(4)
                    .padding(.top,10)
                    .padding(.bottom,10)
                    .padding(.trailing,10)
                    .multilineTextAlignment(TextAlignment.leading)
            }
        }
    }
}


struct ETCDDetiaContentListView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading){
                Text("日志")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .opacity(0.75)
                    .padding(.leading,20)
                    .padding(.top,10)
                    .frame(alignment: .leading)
                Divider().frame(height:0.5)
            }
        }
        
    }
}


struct ETCDetialContentView: View {
    var body: some View {
        GeometryReader { proxy in
            HStack{
                ETCDDetiaContentListView().frame(width: proxy.size.width * 0.5)
                ETCDDetiaContentTextView().frame(width: proxy.size.width * 0.5)
            }
        }
    }
}

