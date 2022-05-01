//
//  ETCDCheckBoxView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/1.
//

import SwiftUI

struct ETCDCheckBoxView: View {
    @Binding var IsChoice: Bool
    var callback:(_ newValue: Bool) -> Void
    var size: Double = 18
    var checkedColor: Color = Color(.systemBlue)
    var uncheckedColor: Color = .gray
    var body: some View {
        Image(systemName: IsChoice ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: self.size, height: self.size)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(IsChoice ? self.checkedColor : self.uncheckedColor)
            .onTapGesture {
                self.IsChoice.toggle()
                callback(!IsChoice)
            }
    }
}

