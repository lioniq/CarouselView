//
//  CarouselView.swift
//  Youli
//
//  Created by JERRY LIU on 9/11/2015.
//  Copyright © 2015 ONTHETALL. All rights reserved.
//
import UIKit
import Foundation

class CarouselView: UIView {
    
    // load nib/xib
    var view: UIView!
    var nibName: String = "CarouselView"
    
    // Remote fetch image urls into rotating scrollView with pageControls
    var imageUrls: [String] = [] {
        didSet{
            self.configSubviews()
            self.setupPhotos()
            
        }
    }
    
    // XIB subviews
    @IBOutlet weak var pageControl: UIPageControl?
    @IBOutlet weak var scrollView: UIScrollView?
    
    // other properites
    var timer: NSTimer = NSTimer()
    var placeholderImage: UIImage = UIImage(named: "placeholder")!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    deinit {
        self.timer.invalidate()
    }
    
    //MARK: subviews
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    private func setup() {
        self.view = loadViewFromNib()
        
        view.frame = self.bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        self.addSubview(self.view)
        
        self.configSubviews()
    }
    
    private func configSubviews() {
        // ScrollView setup
        self.scrollView!.pagingEnabled = true
        self.scrollView!.showsHorizontalScrollIndicator = false
        
        let screenWidth = self.view.frame.width
        let contentWidth = Int(screenWidth) * (self.imageUrls.count + 1)
        
        self.scrollView!.contentSize = CGSize(width: contentWidth, height: 0)
        self.scrollView!.contentOffset = CGPoint(x: screenWidth, y: 0)
        
        // Pagecontrol setup
        self.pageControl!.numberOfPages = self.imageUrls.count
    }
    
    
    //MARK: convenience init
    convenience init(frame: CGRect, imageUrls: [String], placeholderImage: UIImage?) {
        self.init(frame: frame)
        
        self.imageUrls = imageUrls
        
        self.placeholderImage = placeholderImage ?? self.placeholderImage
    
        self.startTimer()
    }
    
    convenience init(frame: CGRect, imageUrls: [String]) {
        self.init(frame: frame, imageUrls: imageUrls, placeholderImage: nil)
    }
    
    private func setupPhotos() {
        
        let n = self.imageUrls.count
        let screenWidth = self.frame.width
        
        for i in 0..<n {
            let imageView = UIImageView(frame: CGRect(x: screenWidth * CGFloat(i + 1), y: 0, width: screenWidth, height: self.frame.height))
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            let imageUrl = self.imageUrls[i]
            let url = NSURL(string: imageUrl)!
            imageView.sd_setImageWithURL(url, placeholderImage: self.placeholderImage)
            
            self.scrollView!.addSubview(imageView)
        }
    }
    
    // MARK: Timer
    func startTimer() {
        self.timer =  NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "timer:", userInfo: "Hello Time", repeats: true)
    }
    
    func disableTimer() {
        self.timer.invalidate()
    }
    
    private func timer(timer: NSTimer) {
        
        let offset = self.scrollView!.contentOffset
        
        if offset.x + self.frame.width >= self.scrollView!.contentSize.width {
            self.scrollView!.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self.scrollView!.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
            
        } else {
            self.scrollView!.setContentOffset(CGPoint(x: offset.x + self.frame.width, y: 0), animated: true)
        }
    }
    

    
}

// MARK: Scrolling
extension CarouselView : UIScrollViewDelegate {
    
    private func nextPage() {
        let offset = self.scrollView!.contentOffset
        let page: NSInteger = NSInteger(offset.x / self.frame.width)
        let maxPages = self.imageUrls.count
        self.pageControl!.currentPage = page - 1 < 0 ? maxPages - 1 : page - 1
    }
    
    private func scrollCircle() {
        let offset = self.scrollView!.contentOffset
        let width = self.frame.width
        let maxPages = self.imageUrls.count
        
        if (offset.x + width > self.scrollView!.contentSize.width) {
            self.scrollView!.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            
        } else if (offset.x < 0) {
            self.scrollView!.setContentOffset(CGPoint(x: maxPages * Int(width), y: 0), animated: false)
        }
        let page: NSInteger  = NSInteger(offset.x / self.frame.width)
        self.pageControl!.currentPage = page - 1 < 0 ? maxPages - 1 : Int(page - 1)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.nextPage()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollCircle()
    }
}