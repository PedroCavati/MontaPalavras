//
//  MainViewController.swift
//  MontaPalavras
//
//  Created by Pedro Henrique Cavalcante de Sousa on 20/11/20.
//

import UIKit
/*
 EXPLICAÇÃO DA LÓGICA UTILIZADA NO PROJETO
 
 Para calcular a pontuação de uma string, eu adicionei uma váriavel computada à String, que através de uma iteração dentre todos os caracteres de uma string, retorna sua pontuação
 let string = "coisas"
 print("-> \(string.score)")
 
 -> 8
 
 Já para encontrar a palavra de maior pontuação dentro do banco de palavras, há um método que utiliza dos seguintes métodos para realizar sua tarefa, além do atributo score explicado acima:
 
 - func count(of substring: String) -> Int
 Este método conta quantas vezes uma substring aparece dentro da string, iterando sobre um range dentro da string que diminui a cada unidade da substring encontrada, ignorando tanto acentuação quanto capitalização.
 let string = "letrasletrAsletrás"
 print("-> \(string.count(of: "a"))")
 
 -> 3
 
 
 - func uncontainedCharacters(of word: String) -> String
 Já este método retorna uma string composta pelos caracteres originais da string, com exceção da primeira ocorrência de cada caracter de word.
 Para fazer isto, ele reorganiza a string de maneira alfabética-invertida e, para cada caracter em word, itera sobre toda a string, removendo o primeiro caracter igual.
 let string = "léteras"
 print("-> \(string.uncontainedCharacter(of: "éra"))")
 
 -> TSEL
 
 - func matchingWord() -> (String?, String)
 Para encontrar palavras válidas, o método itera todas as palavras do banco de palavras, e depois utiliza a função count(of:) para contar quantos caracteres únicos existe em cada palavra, comparando com as ocorrências do mesmo caracter dentro da string. Caso aja menos ocorrências dentro da string, significa que os caracters existentes na string não são capazes de montar aquela palavra e o método passa a iterar a próxima palavra.
 No entanto, se a string possuir todos os caracteres necessários para construir a palavra, o método a marca como válida e, caso seja a primeira palavra válida, a guarda em uma váriavel temporária. Caso já exista uma palavra válida, o método compara o score de ambas para determinar qual tem a maior pontuação e, em caso de empate, o menor tamanho, e armazena a palavra de maior pontuação na variável temporária.
 Depois de iterar por todas as palavras e obter a palavra de maior pontuação, ele usa o método uncontainedCharacters(of:) para remover da string os caracteres utilizados para construir a palavra de maior pontuação.
 Após isso, se o método conseguiu montar alguma palavra com os caracteres, ele retorna uma tupla contendo: (palavraDeMaiorPontuação, caracteresInutilizados).
 Caso ele não consiga montar nenhuma palavra com os caracteres, ele retorna uma tupla contendo: (nil, caracteresInutilizados).
 let string = "oicsastye"
 let resultado = string.matchingWord()
 print("-> \(resultado.0)")
 print("-> \(resultado.1)")
 
 -> COISAS
 -> ETY
 
 
 Após isso, a MainViewController trata os dados para exibi-los da melhor maneira possível para o usuário.
 
 Espero que eu tenha sido claro na explicação e vocês gostem do meu projeto.
 
 Qualquer dúvida que tiverem o desejo de sanar sobre o código ou outra coisa, podem me contatar em:
 pedro.henrique.5566@gmail.com
 ou
 +55 61 9 9983-5004
 
 */

// MARK: - Main View Controller

class MainViewController: UIViewController {
    
    /// Main View instance
    var mainView: MainView { return self.view as! MainView }
    
    /// Word with the highest score that has been found
    var highestScoreWord: String? {
        didSet {
            self.mainView.wordCollectionView.reloadData()
            
            self.mainView.wordCollectionView.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = mainView.wordCollectionView.collectionViewLayout.collectionViewContentSize.height
                }
            }
        }
    }
    
    /// Remaining characters of the string used to find the highestScoreWord
    var remainingCharacters: String? {
        didSet {
            self.mainView.remainingCollectionView.reloadData()
            
            self.mainView.remainingCollectionView.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = mainView.remainingCollectionView.collectionViewLayout.collectionViewContentSize.height
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard adjustments
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Assembling delegates, datasources and actions
        self.mainView.characterTextField.delegate = self
        
        self.mainView.playAction = { [weak self] in
            self?.getResults()
        }
        
        self.mainView.wordCollectionView.delegate = self
        self.mainView.wordCollectionView.dataSource = self
        
        self.mainView.remainingCollectionView.delegate = self
        self.mainView.remainingCollectionView.dataSource = self
        
    }

    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else {return}
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardFrame = keyboardSize.cgRectValue
        
        self.mainView.characterTextField.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .bottom {
                constraint.constant = -keyboardFrame.height
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.mainView.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.mainView.characterTextField.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .bottom {
                constraint.constant = -10
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.mainView.layoutIfNeeded()
        }
        
    }
    
    /**
     Get the results of the inputed string
     */
    func getResults() {
        guard let string =  self.mainView.characterTextField.text else {
            return
        }
        
        let word = string.matchingWord()
        highestScoreWord = word.0
        if let highest = word.0 {
            self.mainView.scoreLabel.text = "Palavra de \(highest.score) pontos:"
        } else {
            self.mainView.scoreLabel.text = "Nenhuma palavra encontrada"
        }
        remainingCharacters = word.1
    }
    
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.mainView.characterTextField.text?.removeAll()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.mainView.play()
        return true
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mainView.wordCollectionView {
            guard let word = highestScoreWord else {
                return 0
            }
            return word.count
        } else {
            guard let word = remainingCharacters else {
                return 0
            }
            return word.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.mainView.wordCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCollectionViewCell
            guard let word = highestScoreWord, let char = word.character(at: indexPath.item) else {
                return cell
            }
            cell.character = char
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCollectionViewCell
            guard let word = remainingCharacters, let char = word.character(at: indexPath.item) else {
                return cell
            }
            cell.character = char
            return cell
        }
    }
    
}
