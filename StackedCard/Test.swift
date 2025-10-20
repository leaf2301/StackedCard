//MARK: No swipe
//import UIKit
//
//class StackedCardsView: UIView {
//    let cards = ["Card 0", "Card 1", "Card 2", "Card 3", "Card 4"]
//    private var cardViews: [UIView] = []
//
//    // Cấu hình
//    private let baseWidth: CGFloat = 370 // Chiều rộng của card đầu tiên
//    private let baseHeight: CGFloat = 208 // Chiều cao của card đầu tiên
//    private let scaleFactor: CGFloat = 0.9 // Tỷ lệ scale cho các card phía sau
//    private let verticalOffset: CGFloat = 30 // Khoảng cách đẩy lên giữa các card
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCards()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupCards()
//    }
//
//    private func setupCards() {
//        for (index, cardName) in cards.enumerated() {
//            let cardView = UIView()
//            cardView.backgroundColor = .white
//            cardView.layer.cornerRadius = 10
//            cardView.layer.borderWidth = 1
//            cardView.layer.borderColor = UIColor.gray.cgColor
//
//            let x = (self.bounds.width - baseWidth) / 2
//            let y = CGFloat(index) * -verticalOffset + 80
//            cardView.frame = CGRect(x: x, y: y, width: baseWidth, height: baseHeight)
//
//            // Áp dụng scale cho các card từ index 1 trở đi
//            if index > 0 {
//                let scale = pow(scaleFactor, CGFloat(index)) // Tính tỷ lệ scale
//                cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//                // Điều chỉnh vị trí x để căn giữa sau khi scale
//                let scaledWidth = baseWidth * scale
//                let adjustedX = (self.bounds.width - scaledWidth) / 2
//                cardView.frame.origin.x = adjustedX
//            }
//
//            // Ẩn card 4 và 5 (index 3, 4)
//            if index >= 3 {
//                cardView.isHidden = true
//            }
//
//            // Thêm label để hiển thị tên card
//            let label = UILabel(frame: cardView.bounds)
//            label.text = cardName
//            label.textAlignment = .center
//            cardView.addSubview(label)
//
//            cardViews.append(cardView)
//            addSubview(cardView)
//        }
//
//        // Đảm bảo card đầu tiên nằm trên cùng
//        cardViews.reversed().forEach { bringSubviewToFront($0) }
//    }
//}

//MARK: Swipe no animation
//import UIKit
//
//class StackedCardsView: UIView {
//    let cards = ["Card 0", "Card 1", "Card 2", "Card 3", "Card 4"]
//    private var cardViews: [UIView] = []
//    private var currentCardIndex = 0 // Track the current top card
//
//    // Configuration
//    private let baseWidth: CGFloat = 370
//    private let baseHeight: CGFloat = 208
//    private let scaleFactor: CGFloat = 0.9
//    private let verticalOffset: CGFloat = 30
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCards()
//        setupGesture()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupCards()
//        setupGesture()
//    }
//
//    private func setupCards() {
//        for (index, cardName) in cards.enumerated() {
//            let cardView = UIView()
//            cardView.backgroundColor = .white
//            cardView.layer.cornerRadius = 10
//            cardView.layer.borderWidth = 1
//            cardView.layer.borderColor = UIColor.gray.cgColor
//
//            let x = (self.bounds.width - baseWidth) / 2
//            let y = CGFloat(index) * -verticalOffset + 80
//            cardView.frame = CGRect(x: x, y: y, width: baseWidth, height: baseHeight)
//
//            // Apply scale for cards from index 1 onward
//            if index > 0 {
//                let scale = pow(scaleFactor, CGFloat(index))
//                cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//                // Center the scaled card
//                let scaledWidth = baseWidth * scale
//                let adjustedX = (self.bounds.width - scaledWidth) / 2
//                cardView.frame.origin.x = adjustedX
//            }
//
//            // Hide cards 3 and 4 (index 3, 4)
//            if index >= 3 {
//                cardView.isHidden = true
//            }
//
//            // Add label to display card name
//            let label = UILabel(frame: cardView.bounds)
//            label.text = cardName
//            label.textAlignment = .center
//            cardView.addSubview(label)
//
//            cardViews.append(cardView)
//            addSubview(cardView)
//        }
//
//        // Ensure the first card is on top
//        cardViews.reversed().forEach { bringSubviewToFront($0) }
//    }
//
//    private func setupGesture() {
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
//        swipeGesture.direction = .left // Right-to-left swipe
//        self.addGestureRecognizer(swipeGesture)
//    }
//
//    @objc private func handleSwipe() {
//        // Check if we can swipe to the next card
//        guard currentCardIndex < cardViews.count - 1 else { return }
//
//        let currentCard = cardViews[currentCardIndex]
//        let nextCard = cardViews[currentCardIndex + 1]
//
//        // Calculate the scale for the next card (before it becomes the top card)
//        let currentScale = pow(scaleFactor, CGFloat(currentCardIndex + 1))
//        let nextScale = 1.0 // Target scale for the next card
//
//        // Animate the current card fading out and moving slightly
//        UIView.animate(withDuration: 0.3, animations: {
//            currentCard.alpha = 0 // Fade out
//            currentCard.transform = CGAffineTransform(translationX: -50, y: 0) // Slight slide to left
//        }) { _ in
//            currentCard.isHidden = true // Hide after animation
//            currentCard.alpha = 1 // Reset alpha
//            currentCard.transform = .identity // Reset transform
//        }
//
//        // Animate the next card scaling up to full size and centering
//        UIView.animate(withDuration: 0.3, animations: {
//            nextCard.isHidden = false
//            nextCard.transform = CGAffineTransform(scaleX: nextScale, y: nextScale)
//
//            // Center the next card
//            let scaledWidth = self.baseWidth * nextScale
//            let adjustedX = (self.bounds.width - scaledWidth) / 2
//            nextCard.frame.origin.x = adjustedX
//            nextCard.frame.origin.y = 80 // Reset to base y position
//        })
//
//        // Update the z-order and scales of remaining cards
//        currentCardIndex += 1
//        updateCardStack()
//    }
//
//    private func updateCardStack() {
//        for (index, cardView) in cardViews.enumerated() {
//            // Skip cards before the current index (already hidden or processed)
//            if index < currentCardIndex {
//                cardView.isHidden = true
//                continue
//            }
//
//            // Calculate scale and position for visible cards
//            let relativeIndex = index - currentCardIndex
//            let scale = pow(scaleFactor, CGFloat(relativeIndex))
//            cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//            // Center the card
//            let scaledWidth = baseWidth * scale
//            let adjustedX = (self.bounds.width - scaledWidth) / 2
//            cardView.frame.origin.x = adjustedX
//            cardView.frame.origin.y = CGFloat(relativeIndex) * -verticalOffset + 80
//
//            // Hide cards beyond index 2 relative to current
//            cardView.isHidden = relativeIndex >= 3
//        }
//
//        // Reorder subviews to maintain correct z-order
//        cardViews.reversed().forEach { bringSubviewToFront($0) }
//    }
//}
//
//
//MARK: swipe with animation
//import UIKit
//
//class StackedCardsView: UIView {
//    let cards = ["Card 0", "Card 1", "Card 2", "Card 3", "Card 4"]
//    private var cardViews: [UIView] = []
//    private var currentCardIndex = 0 // Track the current top card
//
//    // Configuration
//    private let baseWidth: CGFloat = 370
//    private let baseHeight: CGFloat = 208
//    private let scaleFactor: CGFloat = 0.9
//    private let verticalOffset: CGFloat = 30
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCards()
//        setupGesture()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupCards()
//        setupGesture()
//    }
//
//    private func setupCards() {
//        for (index, cardName) in cards.enumerated() {
//            let cardView = UIView()
//            cardView.backgroundColor = .white
//            cardView.layer.cornerRadius = 10
//            cardView.layer.borderWidth = 1
//            cardView.layer.borderColor = UIColor.gray.cgColor
//
//            let x = (self.bounds.width - baseWidth) / 2
//            let y = CGFloat(index) * -verticalOffset + 80
//            cardView.frame = CGRect(x: x, y: y, width: baseWidth, height: baseHeight)
//
//            // Apply scale for cards from index 1 onward
//            if index > 0 {
//                let scale = pow(scaleFactor, CGFloat(index))
//                cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//                // Center the scaled card
//                let scaledWidth = baseWidth * scale
//                let adjustedX = (self.bounds.width - scaledWidth) / 2
//                cardView.frame.origin.x = adjustedX
//            }
//
//            // Hide cards 3 and 4 (index 3, 4)
//            if index >= 3 {
//                cardView.isHidden = true
//            }
//
//            // Add label to display card name
//            let label = UILabel(frame: cardView.bounds)
//            label.text = cardName
//            label.textAlignment = .center
//            cardView.addSubview(label)
//
//            cardViews.append(cardView)
//            addSubview(cardView)
//        }
//
//        // Ensure the first card is on top
//        cardViews.reversed().forEach { bringSubviewToFront($0) }
//    }
//
//    private func setupGesture() {
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
//        swipeGesture.direction = .left // Right-to-left swipe
//        self.addGestureRecognizer(swipeGesture)
//    }
//
//    @objc private func handleSwipe() {
//        // Check if we can swipe to the next card
//        guard currentCardIndex < cardViews.count - 1 else { return }
//
//        let currentCard = cardViews[currentCardIndex]
//        let nextCard = cardViews[currentCardIndex + 1]
//
//        // Bước 1: Animate current card sang trái và fade out
//        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//            currentCard.alpha = 0
//            currentCard.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
//        }) { _ in
//            // Bước 2: Sau khi current card biến mất, animate card tiếp theo
//            nextCard.isHidden = false
//            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//                // Scale card tiếp theo lên 1 và di chuyển đến vị trí trên cùng
//                nextCard.transform = CGAffineTransform(scaleX: 1, y: 1)
//                let scaledWidth = self.baseWidth
//                let adjustedX = (self.bounds.width - scaledWidth) / 2
//                nextCard.frame.origin.x = adjustedX
//                nextCard.frame.origin.y = 80 // Base y position
//            }) { _ in
//                // Reset current card sau khi hoàn tất cả hai animation
//                currentCard.alpha = 1
//                currentCard.transform = .identity
//                currentCard.isHidden = true
//
//                // Cập nhật currentCardIndex và stack
//                self.currentCardIndex += 1
//                self.updateCardStack()
//            }
//        }
//    }
//
//    private func updateCardStack() {
//        for (index, cardView) in cardViews.enumerated() {
//            // Skip cards before the current index
//            if index < currentCardIndex {
//                cardView.isHidden = true
//                continue
//            }
//
//            // Calculate scale and position for visible cards
//            let relativeIndex = index - currentCardIndex
//            let scale = pow(scaleFactor, CGFloat(relativeIndex))
//            cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//            // Center the card
//            let scaledWidth = baseWidth * scale
//            let adjustedX = (self.bounds.width - scaledWidth) / 2
//            cardView.frame.origin.x = adjustedX
//            cardView.frame.origin.y = CGFloat(relativeIndex) * -verticalOffset + 80
//
//            // Hide cards beyond index 2 relative to current
//            cardView.isHidden = relativeIndex >= 3
//        }
//
//        // Reorder subviews to maintain correct z-order
//        cardViews.reversed().forEach { bringSubviewToFront($0) }
//    }
//}
//

// MARK: Swipe right// infinite
//import UIKit
//
//class StackedCardsView: UIView {
//    let cards = ["Card 0", "Card 1", "Card 2", "Card 3", "Card 4"]
//    private var cardViews: [UIView] = []
//    private var currentCardIndex = 0 // Track the current top card
//
//    // Configuration
//    private let baseWidth: CGFloat = 370
//    private let baseHeight: CGFloat = 208
//    private let scaleFactor: CGFloat = 0.9
//    private let verticalOffset: CGFloat = 30
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCards()
//        setupGestures()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupCards()
//        setupGestures()
//    }
//
//    private func setupCards() {
//        for (index, cardName) in cards.enumerated() {
//            let cardView = UIView()
//            cardView.backgroundColor = .white
//            cardView.layer.cornerRadius = 10
//            cardView.layer.borderWidth = 1
//            cardView.layer.borderColor = UIColor.gray.cgColor
//
//            let x = (self.bounds.width - baseWidth) / 2
//            let y = CGFloat(index) * -verticalOffset + 80
//            cardView.frame = CGRect(x: x, y: y, width: baseWidth, height: baseHeight)
//
//            // Apply scale for cards from index 1 onward
//            if index > 0 {
//                let scale = pow(scaleFactor, CGFloat(index))
//                cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//                // Center the scaled card
//                let scaledWidth = baseWidth * scale
//                let adjustedX = (self.bounds.width - scaledWidth) / 2
//                cardView.frame.origin.x = adjustedX
//            }
//
//            // Hide cards 3 and 4 (index 3, 4)
//            if index >= 3 {
//                cardView.isHidden = true
//            }
//
//            // Add label to display card name
//            let label = UILabel(frame: cardView.bounds)
//            label.text = cardName
//            label.textAlignment = .center
//            cardView.addSubview(label)
//
//            cardViews.append(cardView)
//            addSubview(cardView)
//        }
//
//        // Ensure the first card is on top
//        cardViews.reversed().forEach { bringSubviewToFront($0) }
//    }
//
//    private func setupGestures() {
//        // Left swipe
//        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
//        leftSwipeGesture.direction = .left
//        self.addGestureRecognizer(leftSwipeGesture)
//
//        // Right swipe
//        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
//        rightSwipeGesture.direction = .right
//        self.addGestureRecognizer(rightSwipeGesture)
//    }
//
//    @objc private func handleLeftSwipe() {
//        // Animate current card to the left and fade out
//        let currentCard = cardViews[currentCardIndex]
//        let nextCardIndex = (currentCardIndex + 1) % cardViews.count // Loop back to 0 if at the end
//        let nextCard = cardViews[nextCardIndex]
//
//        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//            currentCard.alpha = 0
//            currentCard.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
//        }) { _ in
//            // Animate next card to top position
//            nextCard.isHidden = false
//            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//                nextCard.transform = CGAffineTransform(scaleX: 1, y: 1)
//                let scaledWidth = self.baseWidth
//                let adjustedX = (self.bounds.width - scaledWidth) / 2
//                nextCard.frame.origin.x = adjustedX
//                nextCard.frame.origin.y = 80 // Base y position
//            }) { _ in
//                // Reset current card
//                currentCard.alpha = 1
//                currentCard.transform = .identity
//                currentCard.isHidden = true
//
//                // Update current index (loop to 0 if at the end)
//                self.currentCardIndex = nextCardIndex
//                self.updateCardStack()
//            }
//        }
//    }
//
//    @objc private func handleRightSwipe() {
//        // Animate current card to the right and fade out
////        let currentCard = cardViews[currentCardIndex]
////        let prevCardIndex = (currentCardIndex - 1 + cardViews.count) % cardViews.count // Loop to last card if at 0
////        let prevCard = cardViews[prevCardIndex]
////
////        // Ensure previous card is ready to be shown
////        prevCard.isHidden = false
////        let prevScale = pow(self.scaleFactor, CGFloat(1))
////        prevCard.transform = CGAffineTransform(scaleX: prevScale, y: prevScale)
////        let prevScaledWidth = self.baseWidth * prevScale
////        let prevAdjustedX = (self.bounds.width - prevScaledWidth) / 2
////        prevCard.frame.origin.x = prevAdjustedX
////        prevCard.frame.origin.y = -self.verticalOffset + 80
////
////        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
////            currentCard.alpha = 0
////            currentCard.transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
////        }) { _ in
////            // Animate previous card to top position
////            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
////                prevCard.transform = CGAffineTransform(scaleX: 1, y: 1)
////                let scaledWidth = self.baseWidth
////                let adjustedX = (self.bounds.width - scaledWidth) / 2
////                prevCard.frame.origin.x = adjustedX
////                prevCard.frame.origin.y = 80 // Base y position
////            }) { _ in
////                // Reset current card
////                currentCard.alpha = 1
////                currentCard.transform = .identity
////                currentCard.isHidden = true
////
////                // Update current index (loop to last card if at 0)
////                self.currentCardIndex = prevCardIndex
////                self.updateCardStack()
////            }
////        }
//    }
//
//    private func updateCardStack() {
//        for (index, cardView) in cardViews.enumerated() {
//            // Calculate relative index to current card
//            let relativeIndex = (index - currentCardIndex + cardViews.count) % cardViews.count
//
//            // Apply scale and position
//            let scale = pow(scaleFactor, CGFloat(relativeIndex))
//            cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//            // Center the card
//            let scaledWidth = baseWidth * scale
//            let adjustedX = (self.bounds.width - scaledWidth) / 2
//            cardView.frame.origin.x = adjustedX
//            cardView.frame.origin.y = CGFloat(relativeIndex) * -verticalOffset + 80
//
//            // Show only top 3 cards
//            cardView.isHidden = relativeIndex >= 3
//            cardView.alpha = 1 // Ensure visible cards have full opacity
//        }
//
//        // Reorder subviews to maintain correct z-order
//        cardViews.enumerated().sorted { ($0.offset - self.currentCardIndex + self.cardViews.count) % self.cardViews.count > ($1.offset - self.currentCardIndex + self.cardViews.count) % self.cardViews.count }.forEach { self.bringSubviewToFront($0.element) }
//    }
//}

//MARK: swipe right/ fix animate
//import UIKit
//
//class StackedCardsView: UIView {
//    let cards = ["Card 0", "Card 1", "Card 2", "Card 3", "Card 4"]
//    private var cardViews: [UIView] = []
//    private var currentCardIndex = 0 // Track the current top card
//
//    // Configuration
//    private let baseWidth: CGFloat = 370
//    private let baseHeight: CGFloat = 208
//    private let scaleFactor: CGFloat = 0.9
//    private let verticalOffset: CGFloat = 30
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCards()
//        setupGestures()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupCards()
//        setupGestures()
//    }
//
//    private func setupCards() {
//        for (index, cardName) in cards.enumerated() {
//            let cardView = UIView()
//            cardView.backgroundColor = .white
//            cardView.layer.cornerRadius = 10
//            cardView.layer.borderWidth = 1
//            cardView.layer.borderColor = UIColor.gray.cgColor
//
//            let x = (self.bounds.width - baseWidth) / 2
//            let y = CGFloat(index) * -verticalOffset + 80
//            cardView.frame = CGRect(x: x, y: y, width: baseWidth, height: baseHeight)
//
//            if index > 0 {
//                let scale = pow(scaleFactor, CGFloat(index))
//                cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//                let scaledWidth = baseWidth * scale
//                let adjustedX = (self.bounds.width - scaledWidth) / 2
//                cardView.frame.origin.x = adjustedX
//            }
//
//            if index >= 3 {
//                cardView.isHidden = true
//            }
//
//            let label = UILabel(frame: cardView.bounds)
//            label.text = cardName
//            label.textAlignment = .center
//            cardView.addSubview(label)
//
//            cardViews.append(cardView)
//            addSubview(cardView)
//        }
//
//        cardViews.reversed().forEach { bringSubviewToFront($0) }
//    }
//
//    private func setupGestures() {
//        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
//        leftSwipeGesture.direction = .left
//        self.addGestureRecognizer(leftSwipeGesture)
//
//        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
//        rightSwipeGesture.direction = .right
//        self.addGestureRecognizer(rightSwipeGesture)
//    }
//
//    @objc private func handleLeftSwipe() {
//        let currentCard = cardViews[currentCardIndex]
//        let nextCardIndex = (currentCardIndex + 1) % cardViews.count
//        let nextCard = cardViews[nextCardIndex]
//
//        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//            currentCard.alpha = 0
//            currentCard.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
//        }) { _ in
//            nextCard.isHidden = false
//            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//                nextCard.transform = CGAffineTransform(scaleX: 1, y: 1)
//                let scaledWidth = self.baseWidth
//                let adjustedX = (self.bounds.width - scaledWidth) / 2
//                nextCard.frame.origin.x = adjustedX
//                nextCard.frame.origin.y = 80
//            }) { _ in
//                currentCard.alpha = 1
//                currentCard.transform = .identity
//                currentCard.isHidden = true
//
//                self.currentCardIndex = nextCardIndex
//                self.updateCardStack()
//            }
//        }
//    }
//
//    @objc private func handleRightSwipe() {
//        let currentCard = cardViews[currentCardIndex]
//        let prevCardIndex = (currentCardIndex - 1 + cardViews.count) % cardViews.count
//        let prevCard = cardViews[prevCardIndex]
//
//        // Position previous card off-screen to the left
//        prevCard.isHidden = false
//        prevCard.transform = .identity // Full scale
//        prevCard.alpha = 1
//        prevCard.frame.origin.x = -self.baseWidth
//        prevCard.frame.origin.y = 80
//
//        // Animate both cards simultaneously
//        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//            // Current card slides to the right and fades out
////            currentCard.alpha = 0
//            currentCard.transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
//
//            // Previous card slides from left to top position
//            let scaledWidth = self.baseWidth
//            let adjustedX = (self.bounds.width - scaledWidth) / 2
//            prevCard.frame.origin.x = adjustedX
//        }) { _ in
//            // Reset current card
////            currentCard.alpha = 1
//            currentCard.transform = .identity
//            currentCard.isHidden = true
//
//            // Update current index
//            self.currentCardIndex = prevCardIndex
//            self.updateCardStack()
//        }
//    }
//
//    private func updateCardStack() {
//        for (index, cardView) in cardViews.enumerated() {
//            let relativeIndex = (index - currentCardIndex + cardViews.count) % cardViews.count
//
//            let scale = pow(scaleFactor, CGFloat(relativeIndex))
//            cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//            let scaledWidth = baseWidth * scale
//            let adjustedX = (self.bounds.width - scaledWidth) / 2
//            cardView.frame.origin.x = adjustedX
//            cardView.frame.origin.y = CGFloat(relativeIndex) * -verticalOffset + 80
//
//            cardView.isHidden = relativeIndex >= 3
//            cardView.alpha = 1
//        }
//
//        cardViews.enumerated().sorted { ($0.offset - self.currentCardIndex + self.cardViews.count) % self.cardViews.count > ($1.offset - self.currentCardIndex + self.cardViews.count) % self.cardViews.count }.forEach { self.bringSubviewToFront($0.element) }
//    }
//}

//9/10
//import UIKit
//
//class StackedCardsView: UIView {
//    let cards = ["Card 0", "Card 1", "Card 2", "Card 3", "Card 4"]
//    private var cardViews: [UIView] = []
//    private var currentCardIndex = 0 // Track the current top card
//
//    private var allowRightSwipe: Bool = true
//
//    // Configuration
//    private let baseWidth: CGFloat = 370
//    private let baseHeight: CGFloat = 208
//    private let scaleFactor: CGFloat = 0.9
//    private let verticalOffset: CGFloat = 30
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCards()
//        setupGestures()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupCards()
//        setupGestures()
//    }
//
//    private func setupCards() {
//        for (index, cardName) in cards.enumerated() {
//            let cardView = UIView()
//            cardView.backgroundColor = .white
//            cardView.layer.cornerRadius = 10
//            cardView.layer.borderWidth = 1
//            cardView.layer.borderColor = UIColor.gray.cgColor
//
//            let x = (self.bounds.width - baseWidth) / 2
//            let y = CGFloat(index) * -verticalOffset + 80
//            cardView.frame = CGRect(x: x, y: y, width: baseWidth, height: baseHeight)
//
//            if index > 0 {
//                let scale = pow(scaleFactor, CGFloat(index))
//                cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//                let scaledWidth = baseWidth * scale
//                let adjustedX = (self.bounds.width - scaledWidth) / 2
//                cardView.frame.origin.x = adjustedX
//            }
//
//            if index >= 3 {
//                cardView.isHidden = true
//            }
//
//            let label = UILabel(frame: cardView.bounds)
//            label.text = cardName
//            label.textAlignment = .center
//            cardView.addSubview(label)
//
//            cardViews.append(cardView)
//            addSubview(cardView)
//        }
//
//        cardViews.reversed().forEach { bringSubviewToFront($0) }
//    }
//
//    private func setupGestures() {
//        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
//        leftSwipeGesture.direction = .left
//        self.addGestureRecognizer(leftSwipeGesture)
//
//        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
//        rightSwipeGesture.direction = .right
//        self.addGestureRecognizer(rightSwipeGesture)
//    }
//
//    @objc private func handleLeftSwipe() {
//        let currentCard = cardViews[currentCardIndex]
//        let nextCardIndex = (currentCardIndex + 1) % cardViews.count
//        let nextCard = cardViews[nextCardIndex]
//
//        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//            currentCard.alpha = 0
//            currentCard.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
//        }) { _ in
//            nextCard.isHidden = false
//            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//                nextCard.transform = CGAffineTransform(scaleX: 1, y: 1)
//                let scaledWidth = self.baseWidth
//                let adjustedX = (self.bounds.width - scaledWidth) / 2
//                nextCard.frame.origin.x = adjustedX
//                nextCard.frame.origin.y = 80
//            }) { _ in
//                currentCard.alpha = 1
//                currentCard.transform = .identity
//                currentCard.isHidden = true
//
//                self.currentCardIndex = nextCardIndex
//                self.updateCardStack()
//            }
//        }
//    }
//
//    @objc private func handleRightSwipe() {
//        guard allowRightSwipe else { return }
//        let currentCard = cardViews[currentCardIndex]
//        let prevCardIndex = (currentCardIndex - 1 + cardViews.count) % cardViews.count
//        let prevCard = cardViews[prevCardIndex]
//
//        // Bring previous card to the front to cover the stack
//        bringSubviewToFront(prevCard)
//
//        // Position previous card off-screen to the left
//        prevCard.isHidden = false
//        prevCard.transform = .identity // Full scale
//        prevCard.alpha = 1
//        prevCard.frame.origin.x = -self.baseWidth
//        prevCard.frame.origin.y = 80
//
//        // Animate both cards simultaneously
//        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
//            // Current card slides to the right and fades out
//            currentCard.alpha = 0
//            currentCard.transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
//
//            // Previous card slides from left to top position
//            let scaledWidth = self.baseWidth
//            let adjustedX = (self.bounds.width - scaledWidth) / 2
//            prevCard.frame.origin.x = adjustedX
//        }) { _ in
//            // Reset current card
//            currentCard.alpha = 1
//            currentCard.transform = .identity
//            currentCard.isHidden = true
//
//            // Update current index
//            self.currentCardIndex = prevCardIndex
//            self.updateCardStack()
//        }
//    }
//
//    private func updateCardStack() {
//        for (index, cardView) in cardViews.enumerated() {
//            let relativeIndex = (index - currentCardIndex + cardViews.count) % cardViews.count
//
//            let scale = pow(scaleFactor, CGFloat(relativeIndex))
//            cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//            let scaledWidth = baseWidth * scale
//            let adjustedX = (self.bounds.width - scaledWidth) / 2
//            cardView.frame.origin.x = adjustedX
//            cardView.frame.origin.y = CGFloat(relativeIndex) * -verticalOffset + 80
//
//            cardView.isHidden = relativeIndex >= 3
//            cardView.alpha = 1
//        }
//
//        cardViews.enumerated().sorted { ($0.offset - self.currentCardIndex + self.cardViews.count) % self.cardViews.count > ($1.offset - self.currentCardIndex + self.cardViews.count) % self.cardViews.count }.forEach { self.bringSubviewToFront($0.element) }
//    }
//}
//
