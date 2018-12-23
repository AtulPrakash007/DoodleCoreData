//
//  UserTableViewCell.swift
//  DoodleCoreData
//
//  Created by Atul on 22/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit

protocol UserTableDelegate: class {
    func cellBtnAction(for isFamily: Bool, at index: Int)
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var familyCountBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    weak var delegate: UserTableDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        delegate?.cellBtnAction(for: false, at: sender.tag)
    }
    
    @IBAction func familyAction(_ sender: UIButton) {
        delegate?.cellBtnAction(for: true, at: sender.tag)
    }
    
    
}
