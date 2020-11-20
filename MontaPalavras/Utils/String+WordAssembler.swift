//
//  String+WordAssembler.swift
//  MontaPalavras
//
//  Created by Pedro Henrique Cavalcante de Sousa on 20/11/20.
//

// MARK: - String
extension String {
    
    /// String's score
    var score: Int {
        
        var score: Int = 0
        
        func parse(_ character: Character) {
            score += scoreValue(for: character)
        }
        
        func scoreValue(for character: Character) -> Int {
            switch character.lowercased() {
            case "e", "a", "i", "o", "n", "t", "l", "s", "u":
                return 1
            case "w", "d", "g":
                return 2
            case "b", "c", "m", "p":
                return 3
            case "f", "h", "v":
                return 4
            case "j", "x":
                return 8
            case "q", "z":
                return 10
            default:
                return 0
            }
        }
        
        forEach(parse(_:))

        return score
        
    }
    
    /**
     Search the word database, trying to find a word that can be made with the string's characters
     - returns: a tuple containing the word with the highest score and the remaining characters of the string. If no word in made, it returns (nil, remainingWords)
     */
    func matchingWord() -> (String?, String) {
        let words = ["Abacaxi", "Manada", "mandar", "porta", "mesa", "Dado", "Mangas", "Já", "coisas", "radiografia",
        "matemática", "Drogas", "prédios", "implementação", "computador", "balão", "Xícara", "Tédio",
        "faixa", "Livro", "deixar", "superior", "Profissão", "Reunião", "Prédios", "Montanha", "Botânica",
        "Banheiro", "Caixas", "Xingamento", "Infestação", "Cupim", "Premiada", "empanada", "Ratos",
        "Ruído", "Antecedente", "Empresa", "Emissário", "Folga", "Fratura", "Goiaba", "Gratuito",
        "Hídrico", "Homem", "Jantar", "Jogos", "Montagem", "Manual", "Nuvem", "Neve", "Operação",
        "Ontem", "Pato", "Pé", "viagem", "Queijo", "Quarto", "Quintal", "Solto", "rota", "Selva",
        "Tatuagem", "Tigre", "Uva", "Último", "Vitupério", "Voltagem", "Zangado", "Zombaria", "Dor", "éra"]
        
        var highestScoreWord: String?
        var validWord = true
        
        words.forEach { (word) in
            for character in word {
                if word.count(of: String(character)) > self.count(of: String(character)) {
                    validWord.toggle()
                    break
                }
            }
            
            if validWord {
                if let actualWord = highestScoreWord {
                    // highestScoreWord != nil
                    if actualWord.score < word.score {
                        // If the word's score is higher then the actual highest score word
                        highestScoreWord = word
                    } else if actualWord.score == word.score {
                        // If both word's scores are equal
                        if actualWord.count < word.count {
                            // If the word's length is smaller then the actual highest score word
                            highestScoreWord = word
                        }
                    }
                } else {
                    // If there is no highest score word yet
                    highestScoreWord = word
                }
            } else {
                validWord.toggle()
            }
        }
        if let word = highestScoreWord {
            return (word.uppercased(), uncontainedCharacters(of: word).uppercased())
        } else {
            return (nil, uncontainedCharacters(of: "").uppercased())
        }
        
    }
    
    /**
     Remove the first ocurrence of each character of a word in the string
     - parameters:
        - word: String that will be removed from self
     - returns: a string without the first ocurrence of each character of word in self
     */
    func uncontainedCharacters(of word: String) -> String {
        let sorted = self.sorted(by: >)
        var uncontainedCharacters = String(sorted)
        for charA in word {
            for charB in uncontainedCharacters {
                if charA.uppercased().compare(charB.uppercased(), options: .diacriticInsensitive).rawValue == 0 {
                    if let index = uncontainedCharacters.firstIndex(of: charB) {
                        uncontainedCharacters.remove(at: index)
                        break
                    }
                }
            }
        }
        
        return uncontainedCharacters.replacingOccurrences(of: " ", with: "")
    }
    
    /**
     Counts the number of times a substring appears in self
     - parameters:
        - subString: the substring to be searched in self
     - returns: the number of times the substring appears in self
     */
    func count(of subString: String) -> Int {
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = self.range(of: subString, options: [.diacriticInsensitive, .caseInsensitive], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: self.endIndex))
        }
        return count
    }
    
    /**
     Tries to find the character in a determined index
     - parameters:
        - index: index of the character's position in the string
     - returns: the character at the index. If no character is found, it returns nil.
     */
    func character(at index: Int) -> Character? {
        
        var indexCount: Int = 0
        var character: Character?
        
        for char in self {
            if index == indexCount {
                character = char
                break
            }
            indexCount += 1
        }
        
        if let char = character {
            return char
        }
        
        return nil
    }
    
}

