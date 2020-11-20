//
//  MainView.swift
//  MontaPalavras
//
//  Created by Pedro Henrique Cavalcante de Sousa on 20/11/20.
//

import UIKit

// MARK: - Main View
class MainView: UIView {
    
    /// Action that will get the results of the round.
    var playAction: (() -> Void)?
    
    var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 80/255, green: 100/255, blue: 163/100, alpha: 1.0)
        return view
    }()
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "MONTA PALAVRAS"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 20)
        return titleLabel
    }()
    
    var initialMessageLabel: UILabel = {
        var textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .black
        textView.text = "Digite as letras disponíveis nesta jogada:"
        return textView
    }()
    
    var characterTextField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Digite aqui as letras..."
        textField.borderStyle = .line
        textField.backgroundColor = .white
        textField.textColor = .black
        return textField
    }()
    
    var confirmButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    var scoreLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.text = "Palavra de 0 pontos:"
        label.isHidden = true
        return label
    }()
    
    var remainingLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.text = "Sobraram:"
        label.isHidden = true
        return label
    }()
    
    var wordCollectionView: UICollectionView = {
        var collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionLayout.itemSize = CGSize(width: 30, height: 30)
        var collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCell")
        collectionView.isHidden = true
        return collectionView
    }()
    
    var remainingCollectionView: UICollectionView = {
        var collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionLayout.itemSize = CGSize(width: 30, height: 30)
        var collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCell")
        collectionView.isHidden = true
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func play() {
        playAction?()
        initialMessageLabel.isHidden = true
        scoreLabel.isHidden = false
        wordCollectionView.isHidden = false
        remainingLabel.isHidden = false
        self.remainingCollectionView.isHidden = false
        self.characterTextField.resignFirstResponder()
    }
    
}

// MARK: - View Codable
extension MainView: ViewCodable {
    
    func setupViewHierarchy() {
        
        topView.addSubview(titleLabel)
        
        self.addSubview(topView)
        
        self.addSubview(initialMessageLabel)
        
        self.addSubview(characterTextField)
        
        self.addSubview(confirmButton)
        
        self.addSubview(scoreLabel)
        
        self.addSubview(wordCollectionView)
        
        self.addSubview(remainingLabel)
        
        self.addSubview(remainingCollectionView)
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.rightAnchor.constraint(equalTo: self.rightAnchor),
            topView.heightAnchor.constraint(equalToConstant: 100.0),
            topView.leftAnchor.constraint(equalTo: self.leftAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            
            initialMessageLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            initialMessageLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            characterTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            characterTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            NSLayoutConstraint(item: characterTextField, attribute: .right, relatedBy: .equal, toItem: confirmButton, attribute: .left, multiplier: 1, constant: -10),
            
            confirmButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            confirmButton.centerYAnchor.constraint(equalTo: characterTextField.centerYAnchor),
            
            scoreLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scoreLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 60),
            
            wordCollectionView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            wordCollectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20),
            wordCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            wordCollectionView.heightAnchor.constraint(equalToConstant: wordCollectionView.collectionViewLayout.collectionViewContentSize.height),
            
            remainingLabel.topAnchor.constraint(equalTo: wordCollectionView.bottomAnchor, constant: 40),
            remainingLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            remainingCollectionView.topAnchor.constraint(equalTo: remainingLabel.bottomAnchor, constant: 10),
            remainingCollectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20),
            remainingCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            remainingCollectionView.heightAnchor.constraint(equalToConstant: remainingCollectionView.collectionViewLayout.collectionViewContentSize.height),
        ])
    }
    
    func setupActions() {
        confirmButton.addTarget(self, action: #selector(play), for: .touchUpInside)
    }
}
