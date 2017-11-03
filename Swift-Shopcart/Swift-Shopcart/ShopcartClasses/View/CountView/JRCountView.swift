//
//  JRCountView.swift
//  Swift-Shopcart
//
//  Created by Johnson Rey on 2017/10/30.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

import UIKit

class JRCountView: UIView, UITextFieldDelegate {

    var shopcartCountViewEditBlock:((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(decreaseButton)
        addSubview(editTextField)
        addSubview(increaseButton)
    }
    
    /// 计量数据
    ///
    /// - Parameters:
    ///   - productCount: 商品数量
    ///   - productstock: 商品库存
    func configureShopcartCountViewWithProductCount(productCount:Int, productStock:Int) {
        if productCount == 1 {
            decreaseButton.isEnabled = false
            increaseButton.isEnabled = true
        } else if productCount == productStock {
            decreaseButton.isEnabled = true
            increaseButton.isEnabled = false
        } else {
            decreaseButton.isEnabled = true
            increaseButton.isEnabled = true
        }
        editTextField.text = "\(productCount)"
    }
    
    // MARK: -- 懒加载 getter
    
    private lazy var decreaseButton:UIButton = {
        let decreseBtn_X:CGFloat = 0.0
        let decreseBtn_Y:CGFloat = 0.0
        let decreseBtn_W = bounds.size.width / 3.0
        let decrease = UIButton.init(type: .custom)
        decrease.frame = CGRect.init(x: decreseBtn_X, y: decreseBtn_Y, width: decreseBtn_W, height: bounds.size.height)
        decrease.setBackgroundImage(UIImage.init(named: "product_detail_sub_normal"), for: .normal)
        decrease.setBackgroundImage(UIImage.init(named: "product_detail_sub_no"), for: .disabled)
        decrease.addTarget(self, action: #selector(decreaseButtonAction), for: .touchUpInside)
        return decrease
    }()
    
    private lazy var editTextField:UITextField = {
        
        let editTF_X = bounds.size.width / 3.0
        let editTF_Y:CGFloat = 0.0
        let editTF_W = editTF_X
        let editTF_H = bounds.size.height
        
        let editTF = UITextField.init(frame: CGRect.init(x: editTF_X, y: editTF_Y, width: editTF_W, height: editTF_H))
        editTF.textAlignment = .center
        editTF.font = UIFont.systemFont(ofSize: 13)
        editTF.backgroundColor = UIColor.white
        editTF.layer.borderWidth = 0.5
        editTF.layer.backgroundColor = UIColor.init(red: 0.776, green: 0.780, blue: 0.789, alpha: 1).cgColor
        editTF.keyboardType = .numberPad
        editTF.delegate = self
        
        return editTF
    }()
    
    private lazy var increaseButton:UIButton = {
        let increaseBtn_W = bounds.size.width / 3.0
        let increaseBtn_X  = bounds.size.width - increaseBtn_W
        let increaseBtn_Y:CGFloat = 0.0
        let increase = UIButton.init(type: .custom)
        increase.frame = CGRect.init(x: increaseBtn_X, y: increaseBtn_Y, width: increaseBtn_W, height: bounds.size.height)
        increase.setBackgroundImage(UIImage.init(named: "product_detail_add_normal"), for: .normal)
        increase.setBackgroundImage(UIImage.init(named: "product_detail_add_no"), for: .disabled)
        increase.addTarget(self, action: #selector(increaseButtonAction), for: .touchUpInside)
        return increase
    }()
}

@objc extension JRCountView {
    
    fileprivate func decreaseButtonAction() {
        var count = (editTextField.text! as NSString).integerValue
        count -= 1
        shopcartCountViewEditBlock?(count)
    }
    
    fileprivate func increaseButtonAction() {
        var count = (editTextField.text! as NSString).integerValue
        count += 1
        shopcartCountViewEditBlock?(count)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let count = (textField.text! as NSString).integerValue
        shopcartCountViewEditBlock?(count)
    }
    
}
