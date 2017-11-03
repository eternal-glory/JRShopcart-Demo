//
//  JRShopcartController.swift
//  Swift-Shopcart
//
//  Created by Johnson Rey on 2017/10/27.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

import UIKit

class JRShopcartController: UIViewController,JRShopcartFormatDelegate {
    
    func shopcartFormatRequestProductListDidSuccess(dataArray: [ShopcartBrandModel]?) {
        shopcartTableViewProxy.dataSource = dataArray!
        tableView.reloadData()
    }
    
    func shopcartFormatAccount(totalPrice: Double, totalCount: Int, isAllSelected: Bool) {
        bottomView.configureShopcartBottomViewWithTotalPrice(totalPrice: totalPrice,
                                                             totalCount: totalCount,
                                                             isAllselected: isAllSelected)
        tableView.reloadData()
    }
    
    func shopcartFormarSettle(selectedProducts: [ShopcartBrandModel]?) {
        print("结算操作 \(selectedProducts!.count)")
    }
    
    func shopcartFormatHasDeleteAllProducts() {
        print("清空购物车")
    }
    
    func shopcartFormatWillDelete(selectedProducts: [GoodsListModel]?) {
        shopcartFormat.deleteSelectedProducts(selectedArray: selectedProducts!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: editButton)
        view.addSubview(bottomView)
        
        let plistPath = Bundle.main.path(forResource: "shopcart", ofType: "plist")
        let array = NSArray.init(contentsOfFile: plistPath!) as! Array<Any>
        
        shopcartFormat.requestShopcartProductList(dataArray: array)
    }

    // MARK: --- 懒加载
    
    fileprivate lazy var shopcartFormat :JRShopcartFormat = {
        let shopcartFormat = JRShopcartFormat.init()
        shopcartFormat.delegate = self
        return shopcartFormat
    }()
    
    fileprivate lazy var shopcartTableViewProxy: JRTableViewProxy = {
       
        let tableViewProxy = JRTableViewProxy.init()
        tableViewProxy.shopcartProxyBrandSelectBlock = {
            (isSelected, section) in
            self.shopcartFormat.selectBrandAtSection(section: section, isSelected: isSelected)
        }
        
        tableViewProxy.shopcartProxyProductSelectBlock = {
            (isSelected, indexPath) in
            self.shopcartFormat.selectProductAtIndexPath(indexPath: indexPath, isSelected: isSelected)
        }
        
        tableViewProxy.shopcartProxyChangeCountBlock = {
            (count, indexPath) in
            self.shopcartFormat.changeCountAtIndexPath(indexPath: indexPath, count: count)
        }
        
        tableViewProxy.shopcartProxyDeleteBlock = {
            (indexPath) in
            self.shopcartFormat.deleteProductAtIndexPath(indexPath: indexPath)
        }
        
        return tableViewProxy
    }()
    
    fileprivate lazy var bottomView: ShopcartBottomView = {
       
        let bottomView_X: CGFloat = 0
        let bottomView_W = view.bounds.width
        let bottomView_H: CGFloat = 49
        let bottomView_Y = UIScreen.main.bounds.height - bottomView_H
        
        let bottomView = ShopcartBottomView.init(frame: CGRect.init(x: bottomView_X, y: bottomView_Y, width: bottomView_W, height: bottomView_H))
        
        bottomView.changeShopcartBottomViewWithStatus(status: false)
        
        bottomView.shopcartBotttomViewAllSelectBlock = {
            (isSelect) in
            self.shopcartFormat.selectAllProductWithStatus(isSelected: isSelect)
        }
        
        bottomView.shopcartBotttomViewSettleBlock = {
            () in
            self.shopcartFormat.settleSelectedProducts()
        }
        
        bottomView.shopcartBotttomViewDeleteBlock = {
            () in
            self.shopcartFormat.beginToDeleteSelectedProducts()
        }
        
        return bottomView
    }()
    
    fileprivate lazy var tableView: UITableView = {
       
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - bottomView.frame.height), style: .grouped)
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "ShopcartViewCell", bundle: nil), forCellReuseIdentifier: ShopcartViewCellID)
        tableView.register(ShopcartHeaderView.self, forHeaderFooterViewReuseIdentifier: ShopcartHeaderViewID)
        tableView.dataSource = shopcartTableViewProxy
        tableView.delegate = shopcartTableViewProxy
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.sectionFooterHeight = 0;
        
        return tableView
    }()
    
    fileprivate lazy var editButton: UIButton = {
        let button_H:CGFloat = 44
        let button_W:CGFloat = 55
        let button_X:CGFloat = 0
        let button_Y:CGFloat = 0
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: button_X, y: button_Y, width: button_W, height: button_H)
        btn.setTitle("编辑", for: .normal)
        btn.setTitle("完成", for: .selected)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(JRShopcartController.editButtonAction(button:)), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
}

@objc extension JRShopcartController {
    
    fileprivate func editButtonAction(button: UIButton) {
        button.isSelected = !button.isSelected
        self.bottomView.changeShopcartBottomViewWithStatus(status: button.isSelected)
    }
}
