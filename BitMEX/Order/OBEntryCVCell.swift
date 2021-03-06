//
//  OBEntryCVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/28/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class OBEntryCVCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var progressView: OrderBookProgressView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        amountLabel.text = ""
        priceLabel.text = ""
        progressView.progress = 0
        progressView.setNeedsDisplay()
        amountLabel.setNeedsDisplay()
        priceLabel.setNeedsDisplay()
    }
}
