//
//  ShopcartBottomView.swift
//  Swift-Shopcart
//
//  Created by Johnson Rey on 2017/11/1.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

import UIKit

class ShopcartBottomView: UIView {

    var shopcartBotttomViewAllSelectBlock:((Bool)->())?
    
    var shopcartBotttomViewSettleBlock:(()->())?
    
    var shopcartBotttomViewDeleteBlock:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupIU()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setupIU() {
        
        let limitView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: bounds.width, height: 0.5))
        limitView.backgroundColor = UIColor.lightGray
        addSubview(limitView)
        
        addSubview(allSelectButton)
        addSubview(totalPricelabel)
        addSubview(settleButton)
        addSubview(deleteButton)
        renderWithTotalPrice(totalPrice: totalPricelabel.text!)
    }
    
    func changeShopcartBottomViewWithStatus(status:Bool) {
        deleteButton.isHidden = !status
        totalPricelabel.isHidden = status
    }
    
    func configureShopcartBottomViewWithTotalPrice(totalPrice:Double,
                                                   totalCount:Int,
                                                   isAllselected:Bool? = false) {
        allSelectButton.isSelected = isAllselected!
        totalPricelabel.text = String(format: "合计: ￥%.2f",totalPrice)
        renderWithTotalPrice(totalPrice: totalPricelabel.text!)
        
        settleButton.setTitle(String(format: "结算(%d)",totalCount), for: .normal)
        
        settleButton.isEnabled = (totalCount > 0 || totalPrice > 0) ? true : false
        deleteButton.isEnabled = (totalCount > 0 || totalPrice > 0) ? true : false
        
        if settleButton.isEnabled {
            settleButton.backgroundColor = UIColor.orange
            deleteButton.backgroundColor = UIColor.orange
        } else {
            settleButton.backgroundColor = UIColor.lightGray
            deleteButton.backgroundColor = UIColor.lightGray
        }
    }
    
    fileprivate func renderWithTotalPrice(totalPrice: String) {
        let attributedString = NSMutableAttributedString.init(string: totalPrice)
        let rang = NSRange.init(location: 3, length: (totalPrice as NSString).length - 3)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: rang)
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15), range: rang)
        
        totalPricelabel.attributedText = attributedString
    }
    
    // MARK: --- 懒加载
    fileprivate lazy var allSelectButton: UIButton = {
        let button_X:CGFloat = 10
        let button_W:CGFloat = 60
        let button_H:CGFloat = 30
        let button_Y:CGFloat = (bounds.size.height - button_H) / 2
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: button_X, y: button_Y, width: button_W, height: button_H)
        btn.setImage(UIImage.init(named: "unselected"), for: .normal)
        btn.setImage(UIImage.init(named: "selected"), for: .selected)
        btn.setTitle("全选", for: .normal)
        btn.setTitleColor(UIColor.init(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        btn.addTarget(self, action: #selector(ShopcartBottomView.allSelectButtonAction(button:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var totalPricelabel: UILabel = {
        let label_X = allSelectButton.frame.maxX
        let label_W = bounds.size.width - label_X - settleButton.frame.width - 10
        let label_Y:CGFloat = 0.0
        let label_H = bounds.size.height
        let priceLabel = UILabel.init(frame: CGRect.init(x: label_X, y: label_Y, width: label_W, height: label_H))
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = UIColor.init(red: 120/255.0, green: 120/255.0, blue: 120/255.0, alpha: 1)
        priceLabel.numberOfLines = 1
        priceLabel.text = "合计: ￥0.00"
        priceLabel.textAlignment = .right
        return priceLabel
    }()
    
    fileprivate lazy var settleButton: UIButton = {
        let button_H:CGFloat = bounds.size.height
        let button_W:CGFloat = button_H + 30
        let button_X:CGFloat = frame.width - button_W
        let button_Y:CGFloat = 0
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: button_X, y: button_Y, width: button_W, height: button_H)
        btn.setTitle("结算(0)", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.backgroundColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(ShopcartBottomView.settleButtonAction), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    fileprivate lazy var deleteButton: UIButton = {
        let button_H:CGFloat = bounds.size.height
        let button_W:CGFloat = button_H + 30
        let button_X:CGFloat = frame.width - button_W
        let button_Y:CGFloat = 0
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: button_X, y: button_Y, width: button_W, height: button_H)
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.backgroundColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(ShopcartBottomView.deleteButtonAction), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
}

@objc extension ShopcartBottomView {
    
    fileprivate func allSelectButtonAction(button: UIButton) {
        button.isSelected = !button.isSelected
        shopcartBotttomViewAllSelectBlock?(button.isSelected)
    }
    
    fileprivate func settleButtonAction() {
        shopcartBotttomViewSettleBlock?()
    }
    
    fileprivate func deleteButtonAction() {
        shopcartBotttomViewDeleteBlock?()
    }
}
