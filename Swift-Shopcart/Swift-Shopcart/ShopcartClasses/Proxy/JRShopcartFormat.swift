//
//  JRShopcartFormat.swift
//  Swift-Shopcart
//
//  Created by Johnson Rey on 2017/10/27.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

import UIKit
import YYModel

@objc protocol JRShopcartFormatDelegate {
    
    func shopcartFormatRequestProductListDidSuccess(dataArray:[ShopcartBrandModel]?)
    
    func shopcartFormatAccount(totalPrice:Double,
                               totalCount:Int,
                               isAllSelected:Bool)
    
    /// 结算调用
    ///
    /// - Parameter selectedProducts: 返回商品信息对象数组
    func shopcartFormarSettle(selectedProducts:[ShopcartBrandModel]?)
    
    /// 清空购物车回调
    func shopcartFormatHasDeleteAllProducts()
    
    /// 多选删除
    ///
    /// - Parameter selectedProducts: 被选中的商品数组
    func shopcartFormatWillDelete(selectedProducts:[GoodsListModel]?)
    
    @objc optional func shopcartFormAtEdit(isEdit:Bool)
    
    @objc optional func shopcartDidSelected(product_id:Int)
}

var shopcartListArray = [ShopcartBrandModel]()

class JRShopcartFormat: NSObject {

    var delegate:JRShopcartFormatDelegate?
    
    func requestShopcartProductList(dataArray:Array<Any>) {
        shopcartListArray.removeAll()
        
        // 数据请求位置
        
        for i in 0..<dataArray.count {
            let model = ShopcartBrandModel.yy_model(withJSON: dataArray[i])!
            shopcartListArray.append(model)
        }
        
        delegate?.shopcartFormatRequestProductListDidSuccess(dataArray: shopcartListArray)
    }
    
    func selectProductAtIndexPath(indexPath: IndexPath, isSelected: Bool) {
        let brandModel: ShopcartBrandModel = shopcartListArray[indexPath.section]
        let productModel = brandModel.list![indexPath.row]
        productModel.isSelected = isSelected
        
        var isBrandSelected = true
        
        for productModel in brandModel.list! {
            if !productModel.isSelected! {
                isBrandSelected = false
            }
        }
        brandModel.isSelected = isBrandSelected
        
        delegate?.shopcartFormatAccount(totalPrice: accountTotalPrice(), totalCount: accountTotalCount(), isAllSelected: isAllSelected())
    }
    
    func selectBrandAtSection(section: Int, isSelected: Bool) {
        
        let brandModel = shopcartListArray[section]
        brandModel.isSelected = isSelected
        
        for productModel in brandModel.list! {
            productModel.isSelected = brandModel.isSelected
        }
        
        delegate?.shopcartFormatAccount(totalPrice: accountTotalPrice(), totalCount: accountTotalCount(), isAllSelected: isAllSelected())
    }
    
    func changeCountAtIndexPath(indexPath: IndexPath, count: Int) {
        let brandModel = shopcartListArray[indexPath.section]
        let productModel = brandModel.list![indexPath.row]
        
        var num = count
        if num <= 0 {
            num = 1
        } else if num > productModel.goods_stock as! Int {
            num =  productModel.goods_stock as! Int
        }
        
        productModel.goods_count = num as NSNumber
        
        delegate?.shopcartFormatAccount(totalPrice: accountTotalPrice(), totalCount: accountTotalCount(), isAllSelected: isAllSelected())
    }
    
    func deleteProductAtIndexPath(indexPath:IndexPath) {
        let brandModel = shopcartListArray[indexPath.section]
        let productModel = brandModel.list![indexPath.row]
        print("productModel---- \(String(describing: productModel.goods_id))")
        
        brandModel.list?.remove(at: indexPath.row)
        
        if brandModel.list!.count == 0 {
            shopcartListArray.remove(at: indexPath.section)
        } else {
            if !brandModel.isSelected! {
                
                var isBrandSelected = true
                for aProductModel in brandModel.list! {
                    if !aProductModel.isSelected! {
                        isBrandSelected = false
                        break
                    }
                }
                
                if isBrandSelected {
                    brandModel.isSelected = true
                }
            }
        }
        
        delegate?.shopcartFormatAccount(totalPrice: accountTotalPrice(), totalCount: accountTotalCount(), isAllSelected: isAllSelected())
        
        if shopcartListArray.count == 0 {
            delegate?.shopcartFormatHasDeleteAllProducts()
        }
    }
    
    func deleteSelectedProducts(selectedArray:[GoodsListModel]) {
        
        var emptyArray = [ShopcartBrandModel]()
        
        for brandModel in shopcartListArray {
            (brandModel.list as! NSMutableArray).removeObjects(in: selectedArray)
            
            if brandModel.list!.count == 0 {
                emptyArray.append(brandModel)
            }
        }
        
        if emptyArray.count > 0 {
            (shopcartListArray as! NSMutableArray).removeObjects(in: emptyArray)
        }
        
        delegate?.shopcartFormatAccount(totalPrice: accountTotalPrice(), totalCount: accountTotalCount(), isAllSelected: isAllSelected())
        
        if shopcartListArray.count == 0 {
            delegate?.shopcartFormatHasDeleteAllProducts()
        }
    }
    
    func selectAllProductWithStatus(isSelected: Bool) {
        
        for brandModel in shopcartListArray {
            brandModel.isSelected = isSelected
            for productModel in brandModel.list! {
                productModel.isSelected = isSelected
            }
        }
        
        delegate?.shopcartFormatAccount(totalPrice: accountTotalPrice(), totalCount: accountTotalCount(), isAllSelected: isAllSelected())
    }
    
    func settleSelectedProducts() {
        var settleArray = [ShopcartBrandModel]()
        
        for brandModel in shopcartListArray {
            var selectedArray = [GoodsListModel]()
            
            for productModel in brandModel.list! {
                if productModel.isSelected! {
                    selectedArray.append(productModel)
                }
            }
            
            brandModel.selectedArray = selectedArray
            if selectedArray.count > 0 {
                settleArray.append(brandModel)
            }
        }
        delegate?.shopcartFormarSettle(selectedProducts: settleArray)
    }
    
    func beginToDeleteSelectedProducts() {
        
        var selectedArray = [GoodsListModel]()
        
        for brandModel in shopcartListArray {
            for productModel in brandModel.list! {
                if productModel.isSelected! {
                    selectedArray.append(productModel)
                }
            }
        }
        delegate?.shopcartFormatWillDelete(selectedProducts: selectedArray)
    }
    
    // MARK: --- private methods
    func accountTotalPrice() -> Double {
        var totalPrice = 0.0
        for brandModel in shopcartListArray {
            for productModel in brandModel.list! {
                if productModel.isSelected! {
                    totalPrice += productModel.goods_price!.doubleValue * productModel.goods_count!.doubleValue
                }
            }
        }
        return totalPrice
    }
    
    func accountTotalCount() -> Int {
        var totalCount = 0;
        
        for brandModel in shopcartListArray {
            for productModel in brandModel.list! {
                if productModel.isSelected! {
                    totalCount += productModel.goods_count!.intValue
                }
            }
        }
        return totalCount
    }
    
    func isAllSelected() -> Bool {
        if shopcartListArray.count == 0 {
            return false
        }
        var isAllSelected = true
        
        for brandModel in shopcartListArray {
            if !brandModel.isSelected! {
                isAllSelected = false
            }
        }
        return isAllSelected
    }
}
