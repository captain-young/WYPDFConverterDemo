//
//  ViewController.swift
//  WYPDFConverterSwift
//
//  Created by 杨新威 on 2017/6/20.
//  Copyright © 2017年 杨新威. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var files : Array<String>!
    var types : Array<String>!
    let cellID = "cellID"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    func getData() {
        files = ["多张图片转PDF","抵押贷款","大话Swift 3.0（上）","华为推荐书目","Xcode快捷键","Page","iOS","H5,JS资源","excel操作大全"]
        types = ["image","numbers","key","xls","rtf","pages","ppt","txt","doc"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = files[indexPath.row] + "." + types[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            
        }else{
            let webVc = WYWebViewController()
            webVc.fileName = files[indexPath.row]
            webVc.filePath = Bundle.main.path(forResource: files[indexPath.row], ofType: types[indexPath.row])
            self.navigationController?.pushViewController(webVc, animated: true)
            
        }
    }

}

