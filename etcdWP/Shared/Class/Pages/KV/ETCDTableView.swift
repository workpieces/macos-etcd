//
//  ETCDTableViewViewController.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/23.
//

import Foundation
import SwiftUI
import SnapKit

#if os(macOS)
import Cocoa
class ETCDTableView: NSView
{
    fileprivate var scrollView : NSScrollView!
    fileprivate var tableView : NSTableView!
    fileprivate  var items: [KVData]?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

   fileprivate  func  setupView()
    {
        let columns: [String] = ["id","endpoint","version","dbSize","dbSizeInUse","leader","isLearner","raftTerm","raftIndex","raftAppliedIndex","errors"]
        
        scrollView = NSScrollView()
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        tableView = NSTableView(frame: scrollView.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        
        for columTitle in columns {
            let identifier = columTitle + "Column"
            let columTitleCol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue:identifier))
            columTitleCol.minWidth = 100
            columTitleCol.title = columTitle
            columTitleCol.maxWidth = .infinity
            tableView.addTableColumn(columTitleCol)
        }
        scrollView.documentView =  tableView
    }
    
    public func reloadData(_ item:ItemStore) async{
        self.items = await item.EndpointStatus()
        self.tableView .reloadData()
    }

}

extension ETCDTableView : NSTableViewDelegate,NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.items?.count ?? 0
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let text = NSTextField()
        text.maximumNumberOfLines = 1
        text.isEditable = false
        text.font = NSFont.systemFont(ofSize: 12)
        text.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        text.sizeToFit()
        text.drawsBackground = false
        text.isBordered = false
        text.textColor = NSColor.white
        let item = self.items![row]
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("idColumn") {
            let sid  = item.status?.sid ?? "000000"
            text.stringValue = String(sid.suffix(6))
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("endpointColumn") {
            text.stringValue = item.status?.end_point ?? "http://localhost:2379"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("versionColumn") {
            text.stringValue = item.status?.etcd_version ?? "3.0.0"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("dbSizeColumn") {
            text.stringValue = item.status?.db_size ?? "0 B"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("dbSizeInUseColumn") {
            text.stringValue = item.status?.db_size_in_use ?? "0 B"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("leaderColumn") {
             let ok  = item.status?.is_leader ?? false
            if ok  {
                text.stringValue = "true"
                text.textColor = NSColor.green.withAlphaComponent(0.9)
            }else{
                text.textColor = NSColor.red.withAlphaComponent(0.9)
                text.stringValue = "false"
            }
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("isLearnerColumn") {
            let ok  = item.status?.is_learner ?? false
           if ok  {
               text.stringValue = "true"
           }else{
               text.stringValue = "false"
           }
            
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("raftTermColumn") {
            let value  = item.status?.raft_term;
            text.stringValue = value ?? "0"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("raftIndexColumn") {
            let value  = item.status?.raft_index;
            text.stringValue = value ?? "0"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("raftAppliedIndexColumn") {
            let value  = item.status?.raft_applied_index;
            text.stringValue = value ?? "0"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("errorsColumn") {
            let value  = item.status?.errors;
            text.stringValue = value ?? "None"
        }

        let cell = NSTableCellView()
        cell.addSubview(text)
        text.snp.makeConstraints { make in
            make.edges.equalTo(cell)
        }
        return cell
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = NSTableRowView()
        rowView.isEmphasized = false
        return rowView
    }
}

#else

struct ETCDTableViewRepresentableMobileBootcamp: View {
    var body: some View {
       Text("text")
    }
}

#endif
