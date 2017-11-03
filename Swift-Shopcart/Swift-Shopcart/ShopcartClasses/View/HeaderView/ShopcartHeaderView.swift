//
//  ShopcartHeaderView.swift
//  Swift-Shopcart
//
//  Created by Johnson Rey on 2017/10/31.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

import UIKit

class ShopcartHeaderView: UITableViewHeaderFooterView {

    var shopcartHeaderViewBlock:((Bool)->())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 40.0)
        addSubview(bgView)
        addSubview(selectButton)
        addSubview(brandNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureShopcartHeaderViewWithBrandName(barndName:String?, brandSelect:Bool? = false) {
        selectButton.isSelected = brandSelect ?? false
        brandNameLabel.text = barndName
    }

    // MARK: -- 懒加载
    private lazy var bgView: UIView = {
        let view = UIView.init(frame: bounds)
        view.backgroundColor = UIColor.white
        let limitView = UIView.init(frame: CGRect.init(x: self.selectButton.frame.minX, y: view.frame.maxY - 0.5, width: view.bounds.width, height: 0.5))
        limitView.backgroundColor = UIColor.lightGray
        view.addSubview(limitView)
        
        return view
    }()
    
    private lazy var selectButton:UIButton = {
        let button_X:CGFloat = 15
        let button_W:CGFloat = 30;
        let button_H = button_W
        let button_Y:CGFloat = (bounds.size.height - button_H) / 2.0;
        
        let selectBtn = UIButton.init(type: .custom)
        selectBtn.frame = CGRect.init(x: button_X, y: button_Y, width: button_W, height: button_H)
        selectBtn.setImage(UIImage.init(named: "unselected"), for: .normal)
        selectBtn.setImage(UIImage.init(named: "selected"), for: .selected)
        selectBtn.addTarget(self, action: #selector(ShopcartHeaderView.selectedHeaderViewClick(_:)), for: .touchUpInside)
        return selectBtn
    }()
    
    private lazy var brandNameLabel:UILabel = {
        let label_X = selectButton.frame.maxX + 10
        let label_W = bounds.size.width - label_X
        let label_H = bounds.size.height
        let label_Y:CGFloat = 0.0
        let label = UILabel.init(frame: CGRect.init(x: label_X, y: label_Y, width: label_W, height: label_H))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.init(red: 70/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1)
        return label
    }()
}

@objc extension ShopcartHeaderView {
    
    fileprivate func selectedHeaderViewClick(_ button:UIButton) {
        button.isSelected = !button.isSelected
        shopcartHeaderViewBlock?(button.isSelected)
    }
}

