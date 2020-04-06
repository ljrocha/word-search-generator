//
//  WordSearch.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 4/4/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

// MARK: - Placement type
enum PlacementType: CaseIterable {
    case leftRight
    case rightLeft
    case upDown
    case downUp
    case topLeftBottomRight
    case topRightBottomLeft
    case bottomLeftTopRight
    case bottomRightTopLeft
    
    var movement: (x: Int, y: Int) {
        switch self {
        case .leftRight:
            return (1, 0)
        case .rightLeft:
            return (-1, 0)
        case .upDown:
            return (0, 1)
        case .downUp:
            return (0, -1)
        case .topLeftBottomRight:
            return (1, 1)
        case .topRightBottomLeft:
            return (-1, 1)
        case .bottomLeftTopRight:
            return (1, -1)
        case .bottomRightTopLeft:
            return (-1, -1)
        }
    }
}

// MARK: - Difficulty
enum Difficulty: Int {
    case easy
    case medium
    case hard
    
    var placementTypes: [PlacementType] {
        switch self {
        case .easy:
            return [.leftRight, .upDown].shuffled()
        case .medium:
            return [.leftRight, .rightLeft, .upDown, .downUp].shuffled()
        case .hard:
            return PlacementType.allCases.shuffled()
        }
    }
}

// MARK: - Word search
class Label {
    var letter: Character = " "
}

class WordSearch {
    
    var wordList: WordList?
    
    var includeTitle = true
    var includeGridLines = true
    var includeWords = true
    var gridSize = 10
    var difficulty = Difficulty.medium
    
    var labels = [[Label]]()
    let allLetters = (65...90).map { Character(Unicode.Scalar($0)) }
    
    // MARK: - Make grid
    private func readDefaultValues() {
        includeTitle = UserDefaults.standard.bool(forKey: Key.UserDefaults.titleIncluded)
        includeGridLines = UserDefaults.standard.bool(forKey: Key.UserDefaults.gridLinesIncluded)
        includeWords = UserDefaults.standard.bool(forKey: Key.UserDefaults.wordsIncluded)
        
        gridSize = UserDefaults.standard.integer(forKey: Key.UserDefaults.gridSize)
        
        let storedDifficulty = UserDefaults.standard.integer(forKey: Key.UserDefaults.difficulty)
        if let difficulty = Difficulty(rawValue: storedDifficulty) {
            self.difficulty = difficulty
        }
    }
    
    private func makeGrid() -> [String] {
        labels = (0..<gridSize).map { _ in
            (0..<gridSize).map { _ in Label() }
        }
        
        let placedWords = placeWords()
        fillGaps()
        
        return placedWords
    }
    
    private func fillGaps() {
        for column in labels {
            for label in column {
                if label.letter == " " {
                    label.letter = allLetters.randomElement()!
                }
            }
        }
    }
    
    private func labels(fromX x: Int, y: Int, word: String, movement: (x: Int, y: Int)) -> [Label]? {
        var returnValue = [Label]()
        
        var xPosition = x
        var yPosition = y
        
        for letter in word {
            let label = labels[xPosition][yPosition]
            
            if label.letter == " " || label.letter == letter {
                returnValue.append(label)
                xPosition += movement.x
                yPosition += movement.y
            } else {
                return nil
            }
        }
        
        return returnValue
    }
    
    private func tryPlacing(_ word: String, movement: (x: Int, y: Int)) -> Bool {
        let xLength = (movement.x * (word.count - 1))
        let yLength = (movement.y * (word.count - 1))
        
        let rows = (0..<gridSize).shuffled()
        let cols = (0..<gridSize).shuffled()
        
        for row in rows {
            for col in cols {
                let finalX = col + xLength
                let finalY = row + yLength
                
                if finalX >= 0 && finalX < gridSize && finalY >= 0 && finalY < gridSize {
                    if let returnValue = labels(fromX: col, y: row, word: word, movement: movement) {
                        for (index, letter) in word.enumerated() {
                            returnValue[index].letter = letter
                        }
                        
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    private func place(_ word: String) -> Bool {
        let formattedWord = word.replacingOccurrences(of: " ", with: "").uppercased()
        
        return difficulty.placementTypes.contains {
            tryPlacing(formattedWord, movement: $0.movement)
        }
    }
    
    private func placeWords() -> [String] {
        guard let wordList = wordList else { return [] }
        
        return wordList.words.shuffled().filter(place)
    }
    
    // MARK: - Render PDF
    func render() -> Data {
        readDefaultValues()
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let pageMargin = pageRect.width / 10
        let availableSpace = CGSize(width: pageRect.width - (pageMargin * 2), height: pageRect.height - (pageMargin * 2))
        
        let gridCellSize: CGFloat = 25
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        // Title attributes
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .paragraphStyle: paragraphStyle
        ]
        
        // Grid letter attributes
        let gridLetterFont = UIFont.systemFont(ofSize: 16)
        let gridLetterAttributes: [NSAttributedString.Key: Any] = [
            .font: gridLetterFont,
            .paragraphStyle: paragraphStyle
        ]
        
        // Word attributes
        let wordFont = UIFont.systemFont(ofSize: 12)
        let wordAttributes: [NSAttributedString.Key: Any] = [
            .font: wordFont,
            .paragraphStyle: paragraphStyle
        ]
        
        // Grid margins
        let gridMarginX = (pageRect.width - (gridCellSize * CGFloat(gridSize))) / 2
        let gridMarginY: CGFloat
        if let wordList = wordList, !wordList.title.isEmpty, includeTitle {
            let constrainedRect = CGSize(width: availableSpace.width, height: .greatestFiniteMagnitude)
            let boundingBox = wordList.title.boundingRect(with: constrainedRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: titleAttributes, context: nil)
            gridMarginY = boundingBox.height + pageMargin * 1.5
        } else {
            gridMarginY = pageRect.height / 10
        }
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        return renderer.pdfData { ctx in
            ctx.beginPage()
            
            let placedWords = makeGrid()
            
            // Draw Title
            if let wordList = wordList, !wordList.title.isEmpty, includeTitle {
                let titleRect = CGRect(x: pageMargin, y: pageMargin, width: availableSpace.width, height: gridMarginY - (pageMargin * 1.5))
                wordList.title.draw(in: titleRect, withAttributes: titleAttributes)
            }
            
            // Write Grid
            if includeGridLines {
                for i in 0...gridSize {
                    let linePosition = CGFloat(i) * gridCellSize
                    
                    ctx.cgContext.move(to: CGPoint(x: gridMarginX, y: gridMarginY + linePosition))
                    ctx.cgContext.addLine(to: CGPoint(x: gridMarginX + (CGFloat(gridSize) * gridCellSize), y: gridMarginY + linePosition))
                    
                    ctx.cgContext.move(to: CGPoint(x: gridMarginX + linePosition, y: gridMarginY))
                    ctx.cgContext.addLine(to: CGPoint(x: gridMarginX + linePosition, y: gridMarginY + (CGFloat(gridSize) * gridCellSize)))
                }
                
                ctx.cgContext.setLineCap(.square)
                ctx.cgContext.strokePath()
            }
            
            // Draw Letters
            var xOffset = gridMarginX
            var yOffset = gridMarginY
            
            for column in labels {
                for label in column {
                    let size = String(label.letter).size(withAttributes: gridLetterAttributes)
                    let yPosition = (gridCellSize - size.height) / 2
                    let cellRect = CGRect(x: xOffset, y: yOffset + yPosition, width: gridCellSize, height: gridCellSize)
                    String(label.letter).draw(in: cellRect, withAttributes: gridLetterAttributes)
                    xOffset += gridCellSize
                }
                
                xOffset = gridMarginX
                yOffset += gridCellSize
            }
            
            // Draw Placed Words
            if includeWords {
                let sortedWordString = placedWords.sorted().joined(separator: "     ")
                
                let constrainedRect = CGSize(width: availableSpace.width, height: .greatestFiniteMagnitude)
                let boundingBox = sortedWordString.boundingRect(with: constrainedRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: wordAttributes, context: nil)
                
                let gridHeight = gridCellSize * CGFloat(gridSize)
                
                var wordMarginY = gridMarginY + gridHeight + pageMargin / 2
                if (wordMarginY + boundingBox.height) > (pageRect.height - pageMargin) {
                    wordMarginY = pageMargin
                    ctx.beginPage()
                }
                
                let wordRect = CGRect(x: pageMargin, y: wordMarginY, width: availableSpace.width, height: availableSpace.height - wordMarginY)
                sortedWordString.draw(in: wordRect, withAttributes: wordAttributes)
            }
        }
    }
}
