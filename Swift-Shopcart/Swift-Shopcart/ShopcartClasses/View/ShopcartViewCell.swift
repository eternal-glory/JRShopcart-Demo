//
//  ShopcartViewCell.swift
//  Swift-Shopcart
//
//  Created by Johnson Rey on 2017/10/27.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

import UIKit
import Kingfisher

class ShopcartViewCell: UITableViewCell {

    @IBOutlet weak var productSelectButton: UIButton!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
 

    var shopcartProductSelectBlock:((Bool)->())?
    var shopcartProductChangeCountBlock:((Int)->())?
    
    
    /// 商品数据参数数据
    ///
    /// - Parameters:
    ///   - productURL: 商品图片地址url
    ///   - productName: 商品名称
    ///   - productPrice: 商品价格
    ///   - productCount: 商品数量
    ///   - productStock: 商品库存
    ///   - priductSelected: 商品是否选中
    func configureShopcartCellWithProductURL(productURL:String?,
                                             productName:String?,
                                             productPrice:Double = 0.0,
                                             productCount:Int = 1,
                                             productStock:Int = 1,
                                             productSelected:Bool? = false) {
        productSelectButton.isSelected = productSelected ?? false
        
        productImgView.kf.setImage(with: URL(string: productURL!))
        productNameLabel.text = productName
        productPriceLabel.text = String(format: "￥ %.2f",productPrice)
        
        countViwe.configureShopcartCountViewWithProductCount(productCount: productCount, productStock: productStock)
    }
    
    @IBAction fileprivate func shopcartViewCellClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        shopcartProductSelectBlock?(button.isSelected)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addSubview(countViwe)
    }
    
    // MARK: --- 懒加载
    fileprivate lazy var countViwe: JRCountView = {
        let view_W:CGFloat = 90
        let view_H:CGFloat = 30
        let view_X = UIScreen.main.bounds.size.width - view_W - 15
        let view_Y = self.productPriceLabel.frame.midY
        let view = JRCountView.init(frame: CGRect.init(x: view_X, y: view_Y, width: view_W, height: view_H))
        view.shopcartCountViewEditBlock = {
            (count) in
            self.shopcartProductChangeCountBlock?(count)
        }
        return view
    }()
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
