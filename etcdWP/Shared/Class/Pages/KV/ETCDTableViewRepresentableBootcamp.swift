//
//  ETCDTableViewRepresentableBootcamp.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/23.
//

import SwiftUI

#if os(macOS)
import Cocoa
struct ETCDTableViewRepresentableBootcamp : NSViewRepresentable
{
    @EnvironmentObject var storeObj : ItemStore
    
    func makeNSView(context: Context) -> ETCDTableView {
        let  etcdViewController  = ETCDTableView()
        return etcdViewController;
    }
    
    func updateNSView(_ nsView: ETCDTableView, context: Context) {
        Task{
            await  nsView.reloadData(storeObj)
        }
    }
    
    typealias NSViewType = ETCDTableView
    
    
    func makeCoordinator() -> ETCDCoordinator {
      return ETCDCoordinator()
    }

    class ETCDCoordinator: NSObject {
        
    }
}
    
#else

#endif
