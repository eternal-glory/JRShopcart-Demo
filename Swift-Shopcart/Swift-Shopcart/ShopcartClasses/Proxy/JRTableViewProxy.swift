//
//  JRTableViewProxy.swift
//  Swift-Shopcart
//
//  Created by Johnson Rey on 2017/10/27.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

import UIKit

let ShopcartViewCellID = "ShopcartViewCellID"
let ShopcartHeaderViewID = "ShopcartHeaderViewID"


class JRTableViewProxy: NSObject,UITableViewDelegate,UITableViewDataSource {

    var dataSource = [ShopcartBrandModel]()
    
    var sompleData:[ShopcartBrandModel]?
    
    var shopcartProxyProductSelectBlock:((Bool,IndexPath)->())?
    var shopcartProxyBrandSelectBlock:((Bool,Int)->())?
    var shopcartProxyChangeCountBlock:((Int,IndexPath)->())?
    var shopcartProxyDeleteBlock:((IndexPath)->())?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].list!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopcartViewCellID, for: indexPath) as! ShopcartViewCell
        cell.selectionStyle = .none
        
        let brandModel = dataSource[indexPath.section]
        
        if brandModel.list!.count > indexPath.row {
            
            let productModel = brandModel.list![indexPath.row]
           
            cell.configureShopcartCellWithProductURL(productURL: productModel.goods_img, productName: productModel.goods_name, productPrice: productModel.goods_price!.doubleValue, productCount: productModel.goods_count!.intValue, productStock: productModel.goods_stock!.intValue, productSelected: productModel.isSelected)
        }
        
        cell.shopcartProductSelectBlock = {
            (isSelected:Bool) in
            self.shopcartProxyProductSelectBlock?(isSelected, indexPath)
        }
        
        cell.shopcartProductChangeCountBlock = {
            (count: Int) in
            self.shopcartProxyChangeCountBlock?(count, indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let shopcartHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShopcartHeaderViewID) as! ShopcartHeaderView
                
        if dataSource.count > section {
            let barndModel = dataSource[section]
            shopcartHeaderView.configureShopcartHeaderViewWithBrandName(barndName: barndModel.brandName, brandSelect: barndModel.isSelected)
        }
        
        shopcartHeaderView.shopcartHeaderViewBlock = {
            (isSelected:Bool) in
            self.shopcartProxyBrandSelectBlock?(isSelected, section)
        }
        
        return shopcartHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "删除") { (action, indexPath) in
            
            self.shopcartProxyDeleteBlock?(indexPath)
        }
        return [deleteAction]
    }
}
