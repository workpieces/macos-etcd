//
//  TabButton.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI

struct TabButton: View {
    var image: String
    var title: String
    @Binding var selectTab : String
    var body: some View {
        Button {
            withAnimation {
                selectTab = title
            }
        } label: {
            VStack(spacing: 8.0){
                Image(systemName: image)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(selectTab == title ? .white : .gray)
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 12))
                    .foregroundColor(selectTab == title ? .white : .gray)
            }
        }
        .padding(.vertical,8.0)
        .frame(width: 70.0)
        .contentShape(Rectangle())
        .background(Color.primary.opacity(selectTab == title ? 0.15 : 0))
        .cornerRadius(10.0)
        .buttonStyle(PlainButtonStyle()) 
    }
}
