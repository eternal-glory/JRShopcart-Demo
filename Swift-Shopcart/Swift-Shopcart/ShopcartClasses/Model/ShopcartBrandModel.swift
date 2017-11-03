//
//  ShopcartBrandModel.swift
//  Swift-Shopcart
//
//  Created by Johnson Rey on 2017/10/27.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

import UIKit

class ShopcartBrandModel: NSObject {

    @objc var brandId:String?
    @objc var brandName:String?
    @objc var list:[GoodsListModel]?

    var isSelected:Bool? = false
    
    var selectedArray:[GoodsListModel]?
    
    
    @objc static func modelContainerPropertyGenericClass() -> [String: Any]? {
        return ["list": GoodsListModel.self]
    }
}
