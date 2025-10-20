//
//  StackedCardView.swift
//  StackedCard
//
//  Created by Tran Trung Hieu on 16/10/25.
//

import Foundation
import UIKit

class StackedCardsView: UIView {
    let cards = ["Card 0", "Card 1", "Card 2", "Card 3", "Card 4"]
    private var cardViews: [UIView] = []
    private var currentCardIndex = 0
    
    private let allowRightSwipe: Bool = true
    // Configuration
    private let baseWidth: CGFloat = 370
    private let baseHeight: CGFloat = 208
    private let scaleFactor: CGFloat = 0.9
    private let verticalOffset: CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCards()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCards()
        setupGestures()
    }
    
    private func setupCards() {
        for (index, cardName) in cards.enumerated() {
            let cardView = UIView()
            cardView.backgroundColor = .white
            cardView.layer.cornerRadius = 10
            cardView.layer.borderWidth = 1
            cardView.layer.borderColor = UIColor.gray.cgColor
            
            let x = (self.bounds.width - baseWidth) / 2
            let y = CGFloat(index) * -verticalOffset + 80
            cardView.frame = CGRect(x: x, y: y, width: baseWidth, height: baseHeight)
            
            if index > 0 {
                let scale = pow(scaleFactor, CGFloat(index))
                cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
                let scaledWidth = baseWidth * scale
                let adjustedX = (self.bounds.width - scaledWidth) / 2
                cardView.frame.origin.x = adjustedX
            }
            
            if index >= 3 {
                cardView.isHidden = true
            }
            
            let label = UILabel(frame: cardView.bounds)
            label.text = cardName
            label.textAlignment = .center
            cardView.addSubview(label)
            
            cardViews.append(cardView)
            addSubview(cardView)
        }
        
        cardViews.reversed().forEach { bringSubviewToFront($0) }
    }
    
    private func setupGestures() {
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        leftSwipeGesture.direction = .left
        self.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        rightSwipeGesture.direction = .right
        self.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc private func handleLeftSwipe() {
        let currentCard = cardViews[currentCardIndex]
        let nextCardIndex = (currentCardIndex + 1) % cardViews.count
        let nextCard = cardViews[nextCardIndex]
        
        // Cards for new stack positions
        let secondCardIndex = (nextCardIndex + 1) % cardViews.count
        let secondCard = cardViews[secondCardIndex]
        let thirdCardIndex = (nextCardIndex + 2) % cardViews.count
        let thirdCard = cardViews[thirdCardIndex]
        
        // Prepare third card (fade in from hidden)
        thirdCard.isHidden = false
        thirdCard.alpha = 0
        let thirdScale = pow(self.scaleFactor, 2)
        thirdCard.transform = CGAffineTransform(scaleX: thirdScale, y: thirdScale)
        let thirdScaledWidth = self.baseWidth * thirdScale
        let thirdAdjustedX = (self.bounds.width - thirdScaledWidth) / 2
        thirdCard.frame.origin.x = thirdAdjustedX
        thirdCard.frame.origin.y = 2 * -self.verticalOffset + 80
        
        // Animate all simultaneously
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            // Current out
            currentCard.alpha = 0
            currentCard.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
            
            // Next to top
            nextCard.transform = CGAffineTransform(scaleX: 1, y: 1)
            let scaledWidth = self.baseWidth
            let adjustedX = (self.bounds.width - scaledWidth) / 2
            nextCard.frame.origin.x = adjustedX
            nextCard.frame.origin.y = 80
            
            // Second to second pos
            let secondScale = self.scaleFactor
            secondCard.transform = CGAffineTransform(scaleX: secondScale, y: secondScale)
            let secondScaledWidth = self.baseWidth * secondScale
            let secondAdjustedX = (self.bounds.width - secondScaledWidth) / 2
            secondCard.frame.origin.x = secondAdjustedX
            secondCard.frame.origin.y = -self.verticalOffset + 80
            
            // Third fade in
            thirdCard.alpha = 1
        }) { _ in
            currentCard.alpha = 1
            currentCard.transform = .identity
            currentCard.isHidden = true
            
            self.currentCardIndex = nextCardIndex
            self.updateCardStack()
        }
    }
    // Animate right swipe
    @objc private func handleRightSwipe() {
        guard allowRightSwipe else { return }
        let currentCard = cardViews[currentCardIndex]
        let prevCardIndex = (currentCardIndex - 1 + cardViews.count) % cardViews.count
        let prevCard = cardViews[prevCardIndex]
        
        // Cards for new stack positions
        let secondCardIndex = currentCardIndex
        let secondCard = cardViews[secondCardIndex]
        let thirdCardIndex = (currentCardIndex + 1) % cardViews.count
        let thirdCard = cardViews[thirdCardIndex]
        
        // Prepare third card (already positioned correctly, just ensure visibility)
        thirdCard.isHidden = false
        
        // Bring previous card to front
        bringSubviewToFront(prevCard)
        
        // Set initial state for previous card (coming from left)
        prevCard.isHidden = false
        prevCard.transform = .identity
        prevCard.alpha = 1
        prevCard.frame.origin.x = -self.baseWidth
        prevCard.frame.origin.y = 80
        
        // Animate all simultaneously
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            // Current card out to the right
            currentCard.alpha = 1
            currentCard.transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
            
            // Previous card to top position
            let scaledWidth = self.baseWidth
            let adjustedX = (self.bounds.width - scaledWidth) / 2
            prevCard.frame.origin.x = adjustedX
            prevCard.transform = CGAffineTransform(scaleX: 1, y: 1)
            prevCard.frame.origin.y = 80
            
            // Current card to second position
            let secondScale = self.scaleFactor
            secondCard.transform = CGAffineTransform(scaleX: secondScale, y: secondScale)
            let secondScaledWidth = self.baseWidth * secondScale
            let secondAdjustedX = (self.bounds.width - secondScaledWidth) / 2
            secondCard.frame.origin.x = secondAdjustedX
            secondCard.frame.origin.y = -self.verticalOffset + 80
            
            // Third card to third position
            let thirdScale = pow(self.scaleFactor, 2)
            thirdCard.transform = CGAffineTransform(scaleX: thirdScale, y: thirdScale)
            let thirdScaledWidth = self.baseWidth * thirdScale
            let thirdAdjustedX = (self.bounds.width - thirdScaledWidth) / 2
            thirdCard.frame.origin.x = thirdAdjustedX
            thirdCard.frame.origin.y = 2 * -self.verticalOffset + 80
        }) { _ in
            // Reset current card
            currentCard.alpha = 1
            currentCard.transform = .identity
            currentCard.isHidden = true
            
            self.currentCardIndex = prevCardIndex
            self.updateCardStack()
        }
    }

    
//    @objc private func handleRightSwipe() {
//        guard allowRightSwipe else { return }
//        let currentCard = cardViews[currentCardIndex]
//        let prevCardIndex = (currentCardIndex - 1 + cardViews.count) % cardViews.count
//        let prevCard = cardViews[prevCardIndex]
//        
//        bringSubviewToFront(prevCard)
//        
//        prevCard.isHidden = false
//        prevCard.transform = .identity
//        prevCard.alpha = 1
//        prevCard.frame.origin.x = -self.baseWidth
//        prevCard.frame.origin.y = 80
//        
//        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//            currentCard.alpha = 0
//            currentCard.transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
//            
//            let scaledWidth = self.baseWidth
//            let adjustedX = (self.bounds.width - scaledWidth) / 2
//            prevCard.frame.origin.x = adjustedX
//        }) { _ in
//            currentCard.alpha = 1
//            currentCard.transform = .identity
//            currentCard.isHidden = true
//            
//            self.currentCardIndex = prevCardIndex
//            self.updateCardStack()
//        }
//    }
    
    private func updateCardStack() {
        for (index, cardView) in cardViews.enumerated() {
            let relativeIndex = (index - currentCardIndex + cardViews.count) % cardViews.count
            
            let scale = pow(scaleFactor, CGFloat(relativeIndex))
            cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            let scaledWidth = baseWidth * scale
            let adjustedX = (self.bounds.width - scaledWidth) / 2
            cardView.frame.origin.x = adjustedX
            cardView.frame.origin.y = CGFloat(relativeIndex) * -verticalOffset + 80
            
            cardView.isHidden = relativeIndex >= 3
            cardView.alpha = 1
        }
        
        // Z-order: higher relative index on top
        cardViews.enumerated().sorted {
            let rel0 = ($0.offset - self.currentCardIndex + self.cardViews.count) % self.cardViews.count
            let rel1 = ($1.offset - self.currentCardIndex + self.cardViews.count) % self.cardViews.count
            return rel0 > rel1
        }.forEach { self.bringSubviewToFront($0.element) }
    }
}
