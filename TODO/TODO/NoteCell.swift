//
//  NoteCell.swift
//  TODO
//
//  Created by Satsishur on 15.12.2020.
//

import UIKit

class NoteCell: UICollectionViewCell {
    static let identidier = "cell"
        
    var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Название"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(red: 0.078, green: 0.08, blue: 0.087, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var cellBackgroundColor: UIColor = NoteColors.blue {
        didSet{
            contentView.backgroundColor = cellBackgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 5
    }
    
    func setupLayout() {
        contentView.backgroundColor = cellBackgroundColor
        contentView.addSubview(titleLabel)
        let margin = contentView.layoutMarginsGuide
        titleLabel.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
    }
}
