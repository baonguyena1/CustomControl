//
//  ShadowView.swift
//  ChartDemo
//
//  Created by Bao Nguyen on 11/10/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: -15, height: 20)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5

    }

}
