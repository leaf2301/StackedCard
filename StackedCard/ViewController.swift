//
//  ViewController.swift
//  StackedCard
//
//  Created by Tran Trung Hieu on 16/10/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let stackedCardsView = StackedCardsView(frame: CGRect(x: (view.bounds.width - 370) / 2, y: 100, width: 370, height: 282))
        view.addSubview(stackedCardsView)
        stackedCardsView.backgroundColor = .green
    }
    
    private func setupUI() {
        
    }


}
