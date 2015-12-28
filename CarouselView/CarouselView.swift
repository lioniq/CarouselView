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
    
    var imageViews = [UIImageView]()
    
    // XIB subviews
    @IBOutlet weak var pageControl: UIPageControl?
    @IBOutlet weak var scrollView: UIScrollView?
    
    // other properites
    var timer: NSTimer = NSTimer()
    var placeholderImage: UIImage = UIImage(named: "placeholder")!

    // MARK: Lifecycle
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
    
    //MARK: setup subviews
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
        
        view.addConstraints(self.constraints)
        
        self.addSubview(self.view)
        
        self.configSubviews()
        self.scrollView?.delegate = self
    }
    
    private func configSubviews() {
        // ScrollView setup
        self.scrollView!.pagingEnabled = true
        self.scrollView!.showsHorizontalScrollIndicator = false
        
        resizeScrollView()
        
        // Pagecontrol setup
        self.pageControl!.numberOfPages = self.imageUrls.count
    }
    
    // MARK: layout subviews
    override func layoutSubviews() {
//        super.layoutSubviews()
        resizeScrollView()
        layoutImageViews()
        
        print("[CarouselView layoutSubviews] imageView.frame: \(self.imageViews.first!.frame)")
    }
    
    // resize imageViews when scrollView or parent views are laid out
    private func layoutImageViews() {
        let n = self.imageViews.count
        let screenWidth = self.scrollView!.frame.width
        let screenHeight = self.scrollView!.frame.height
        
        for i in 0..<n {
            self.imageViews[i].frame = CGRectMake(screenWidth * CGFloat(i), 0, screenWidth, screenHeight)
        }
    }
    
    private func resizeScrollView() {
        let screenWidth = self.view.frame.width
        let contentWidth = Int(screenWidth) * (self.imageUrls.count + 1)
        
        self.scrollView!.contentSize = CGSize(width: contentWidth, height: 0)
        self.scrollView!.contentOffset = CGPoint(x: screenWidth, y: 0)
    }
    
    //MARK: convenience init
    convenience init(frame: CGRect, imageUrls: [String], placeholderImage: UIImage?) {
        self.init(frame: frame)
        self.placeholderImage = placeholderImage ?? self.placeholderImage
        
        self.imageUrls = imageUrls
        self.configSubviews()
        self.setupPhotos()
        self.startTimer()
    }
    
    convenience init(frame: CGRect, imageUrls: [String]) {
        self.init(frame: frame, imageUrls: imageUrls, placeholderImage: nil)
    }
    
    private func setupPhotos() {
        
        let n = self.imageUrls.count
        let screenWidth = self.scrollView!.frame.width
        let screenHeight = self.scrollView!.frame.height
        
        // reset
        self.imageViews = [UIImageView]()
        
        addFirstImageView(CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        for i in 0..<n {
            
            let imageViewFrame = CGRect(x: screenWidth * CGFloat(i + 1), y: 0, width: screenHeight, height: screenHeight)
            let imageUrl = self.imageUrls[i]
            addSubImageView(imageViewFrame, imageURL: imageUrl)
        }
    }
    
    func addSubImageView(imageViewFrame: CGRect, imageURL: String) {
        
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        let url = NSURL(string: imageURL)!
        imageView.sd_setImageWithURL(url, placeholderImage: self.placeholderImage)
        self.imageViews.append(imageView)
        self.scrollView!.addSubview(imageView)
    }
    
    func addFirstImageView(firstFrame: CGRect) {
        
        let firstImageView = UIImageView(frame: firstFrame)
        firstImageView.clipsToBounds = true
        firstImageView.contentMode = UIViewContentMode.ScaleAspectFill
        firstImageView.sd_setImageWithURL(NSURL(string: imageUrls.last!), placeholderImage: self.placeholderImage)
        self.imageViews.append(firstImageView)
        self.scrollView?.addSubview(firstImageView)
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