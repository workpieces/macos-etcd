//
//  ETCDKVItemView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/19.
//

import SwiftUI

struct ETCDKVItemView: View {
    let item:KVData
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: DefaultKeyImageName)
                    .foregroundColor(.orange)
                    .font(.system(size: 14.0))
                Text(item.key!)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .truncationMode(.middle)
                Spacer()
                if item.size != nil {
                    Text(item.size!)
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .truncationMode(.middle)
                }
            }
        }
    }
}


struct ETCDNodeOutlineKVItemView: View {
    let item:KVData
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: DefaultKeyImageName)
                    .foregroundColor(.orange)
                    .font(.system(size: 14.0))
                Text(item.key!)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text("")
                    .frame(minWidth: 150, maxWidth: .infinity)
                    .background(Color(hex: "#221C27"))
                if item.size != nil {
                    Text(item.size!)
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .truncationMode(.middle)
                }
            }
        }
    }
}
