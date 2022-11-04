//
//  HotelDealsTVCell.swift
//  BeeoonsApp
//
//  Created by MA673 on 16/08/22.
//

import UIKit

class HotelDealsTVCell: TableViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var dealsCV: UICollectionView!
    
    
    var key = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCV()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateUI() {
        self.key = cellInfo?.key1 ?? ""
    }
    
    
    func setupCV() {
        contentView.backgroundColor = .AppBGcolor
        holderView.backgroundColor = .AppBGcolor
        dealsCV.backgroundColor = .AppBGcolor
        let nib = UINib(nibName: "HotelDealsCVCell", bundle: nil)
        dealsCV.register(nib, forCellWithReuseIdentifier: "cell")
        dealsCV.delegate = self
        dealsCV.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 156, height: 190)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        dealsCV.collectionViewLayout = layout
        dealsCV.layer.cornerRadius = 4
        dealsCV.clipsToBounds = true
        dealsCV.showsHorizontalScrollIndicator = false
        
    }
    
}



extension HotelDealsTVCell:UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var commonCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? HotelDealsCVCell {
            
            if self.key == "flight" {
                cell.dealsImg.image = UIImage(named: "flight1")
                cell.citylbl.text = "London - New York"
                cell.countrylbl.text = "United Kingdom - USA"
                cell.kwdlbl.text = "KWD 150"
            }else {
                cell.dealsImg.image = UIImage(named: "hotel")
                cell.citylbl.text = "Kuwait"
                cell.countrylbl.text = "5 Star Laxirious Hotel"
                cell.kwdlbl.text = "KWD 150"
            }
            commonCell = cell
        }
        return commonCell
    }
    
    
}

