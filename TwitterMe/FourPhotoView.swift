//
//  FourPhotoView.swift
//  MediaDisplay
//
//  Created by Eduardo Carrillo on 1/3/18.
//  Copyright © 2018 Eduardo Carrillo. All rights reserved.
//

import UIKit

class FourPhotoView: UIView {
    
    
    @IBOutlet var contentView: UIView!
    
    
   //TOP LEFT Corner
    @IBOutlet weak var firstImageView: UIImageView!
    
    //Top right corner
    @IBOutlet weak var secondImageView: UIImageView!
    
    
    //Bottom left corner
    @IBOutlet weak var thirdImageView: UIImageView!
    
    //Bottom right corner
    @IBOutlet weak var fourthImageView: UIImageView!
    
    
    var firstPhoto: UIImage? {
        didSet{
            guard let firstImage = firstPhoto else {
                print("Image is nil")
                return
            }
            
            firstImageView.image = firstImage
        }
    }
    
    var secondPhoto: UIImage? {
        didSet{
            guard let secondImage = firstPhoto else {
                print("Image is nil")
                return
            }
            
            secondImageView.image = secondImage
        }
    }
    
    
    var thirdPhoto: UIImage? {
        didSet{
            guard let thirdImage = thirdPhoto else {
                print("Image is nil")
                return
            }
            
            thirdImageView.image = thirdImage
        }
    }
    
    
    var fourPhoto: UIImage? {
        didSet{
            guard let fourthImage = fourPhoto else {
                print("Image is nil")
                return
            }
            
            fourthImageView.image = fourthImage
        }
    }
    
    
    
    var firstURL: URL? {
        didSet{
            guard let firstURL = firstURL else {
                print("Could not extract first URL")
                return
            }
            self.firstImageView.setImageWith(firstURL)
        }
    }
    
    
    var secondURL: URL? {
        didSet{
            guard let secondURL = secondURL else {
                print("Could not extract first URL")
                return
            }
            self.secondImageView.setImageWith(secondURL)
        }
    }
    
    
    var thirdURL: URL? {
        didSet{
            guard let thirdURL = thirdURL else {
                print("Could not extract first URL")
                return
            }
            self.thirdImageView.setImageWith(thirdURL)
        }
    }
    
    
    var fourthURL: URL? {
        didSet{
            guard let fourthURL = fourthURL else {
                print("Could not extract first URL")
                return
            }
            self.fourthImageView.setImageWith(fourthURL)
        }
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        initSubviews()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initSubviews()
    }
    
    
    func initSubviews(){
        let nib = UINib(nibName: "FourPhotoView", bundle: nil)
        
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.clipsToBounds = true
        
        //Make the corners more rounded
        self.layer.cornerRadius = 10
        addSubview(contentView)
        
        
    }
    
    
    
    
}
