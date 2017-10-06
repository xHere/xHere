//
//  XHERNavigationTitleView.swift
//  xHere
//
//  Created by Chi Hwa Michael Ting on 9/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit

class XHERNavigationTitleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var imageView: UIImageView
    

    override init(frame: CGRect) {
        self.imageView = UIImageView(frame: .zero)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        super.init(frame: frame)
        self.addSubview(self.imageView)

        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        
        self.clipsToBounds = true
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        print("|||||||||||||||||SIZE |\(size.debugDescription)")
        self.frame.size.height = size.height
        self.frame.size.width = size.width
        print("||||||||||||||||TitleViewSize \(self.frame.debugDescription)")

        self.layoutIfNeeded()
        print("||||||||||||||||ImageViewSize \(imageView.frame.debugDescription)")

        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("||||||||||||||||||||||| layout subview \(self.frame.debugDescription)")
        self.imageView.frame = self.frame
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func findNavigationBar() -> UINavigationBar? {
        var superView = self as UIView?
        while superView != nil {
            superView = superView?.superview
            
            if superView is UINavigationBar {
                return superView as! UINavigationBar
            }
        }
        return nil
    }
}
