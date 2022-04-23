//
//  ETCDTableViewViewController.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/23.
//

import Foundation
import Cocoa
import SnapKit
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
        scrollView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
        tableView = NSTableView(frame: scrollView.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        
        for columTitle in columns {
            let identifier = columTitle + "Column"
            let columTitleCol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue:identifier))
            columTitleCol.width = 100
            columTitleCol.title = columTitle
            columTitleCol.maxWidth = .infinity
            tableView.addTableColumn(columTitleCol)
        }
        scrollView.documentView =  tableView
    }
    
    public func reloadData(_ item:ItemStore){
        self.items = item.EndpointStatus()
        self.tableView .reloadData()
    }

}

extension ETCDTableView : NSTableViewDelegate,NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.items?.count ?? 0
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let text = NSTextField()
        let item = self.items![row]
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("idColumn") {
            text.stringValue = item.status?.sid ?? "0"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("endpointColumn") {
            text.stringValue = item.status?.end_point ?? "localhost:2379"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("versionColumn") {
            text.stringValue = item.status?.etcd_version ?? "0.0.0"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("dbSizeColumn") {
            text.stringValue = item.status?.db_size ?? "0 KB"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("dbSizeInUseColumn") {
            text.stringValue = item.status?.db_size_in_use ?? "0KB"
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("leaderColumn") {
            let value  = item.status?.is_leader as! String;
            text.stringValue = value 
        }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("isLearnerColumn") {
            let value  = item.status?.is_leader as! String;
            text.stringValue = value
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
            text.stringValue = value ?? "0"
        }

        let cell = NSTableCellView()
        cell.addSubview(text)
        text.drawsBackground = false
        text.isBordered = false
        text.translatesAutoresizingMaskIntoConstraints = false
        cell .addSubview(text)
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
