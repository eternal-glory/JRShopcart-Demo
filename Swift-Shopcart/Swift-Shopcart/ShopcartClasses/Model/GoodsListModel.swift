//
//  GoodsListModel.swift
//  Swift-Shopcart
//
//  Created by Johnson Rey on 2017/10/27.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

import UIKit

class GoodsListModel: NSObject {
    /// 商品id
    @objc var goods_id:String?
    /// 商品图片
    @objc var goods_img:String?
    /// 商品名称
    @objc var goods_name:String?
    /// 商品库存
    @objc var goods_stock:NSNumber?
    /// 商品数量
    @objc var goods_count:NSNumber?
    /// 商品价格
    @objc var goods_price:NSNumber?
    /// 商品原价
    @objc var origin_price:NSNumber?
    /// 记录相应的row是否选中 (自定义)
    var isSelected:Bool? = false
}
