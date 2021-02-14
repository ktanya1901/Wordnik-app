//
//  CardView.swift
//  Wordnik
//
//  Created by Tatyana Korotkova on 13.02.2021.
//

import UIKit

final class CardView: UIView {

    lazy var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect = .zero){
        super.init(frame: frame)
        setupViews()
        setupStyles()
    }
    
    public func setText(_ text: String){
        self.textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupStyles(){
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 10 , height: 10)
    }

}
