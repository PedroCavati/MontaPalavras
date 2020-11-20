//
//  CharacterCollectionViewCell.swift
//  MontaPalavras
//
//  Created by Pedro Henrique Cavalcante de Sousa on 20/11/20.
//

import UIKit

// MARK: - Character Collection View Cell
class CharacterCollectionViewCell: UICollectionViewCell {
    
    var character: Character? {
        didSet {
            if let char = character {
                characterLabel.text = String(char)
            }
        }
    }
    
    var characterLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 10.0
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - View Codable
extension CharacterCollectionViewCell: ViewCodable {
    
    func setupViewHierarchy() {
        self.addSubview(characterLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            characterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            characterLabel.topAnchor.constraint(equalTo: self.topAnchor),
            characterLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            characterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupActions() {
        
    }
    
}
