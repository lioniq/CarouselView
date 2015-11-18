//
//  CarouselViewDemoTests.swift
//  CarouselViewDemoTests
//
//  Created by JERRY LIU on 17/11/2015.
//  Copyright © 2015 ONTHETALL. All rights reserved.
//

import XCTest
@testable import CarouselViewDemo

class CarouselViewTests: XCTestCase {
    
    let view = UIView(frame: CGRectMake(0, 0, 375, 200))
    var carouselView: CarouselView?
    
    let imageUrls = [
        "http://someapi.com/thisimageurl1.jpg",
        "http://someapi.com/thisimageurl2.jpg",
        "http://someapi.com/thisimageurl3.jpg"]
    
    
    override func setUp() {
        super.setUp()
        carouselView = CarouselView(frame: view.frame, imageUrls: imageUrls)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContentSize() {
        let w = self.view.frame.width
        
        // width should be images.count + 1, for circular scroll
        let content_width = w * CGFloat(imageUrls.count + 1)
        XCTAssertEqual(content_width, carouselView!.scrollView!.contentSize.width)
    }
    
    func testPages() {
        XCTAssertEqual(imageUrls.count, carouselView!.pageControl!.numberOfPages)
    }
    
//    func testPageControl() {
//        
//        carouselView!.layoutSubviews()
//        
//        // 8x left and right margin
//        let pcWidth = self.view.frame.width - (2 * 8)
//        
//        // 18px bottom margin
//        let pcY = self.view.frame.height - carouselView!.pageControl!.frame.height - 18
//        
//        XCTAssertEqual(pcWidth, carouselView!.pageControl!.frame.width)
//        XCTAssertEqual(pcY, carouselView!.pageControl!.frame.origin.y)
//    }
    
    func testTimer() {
        XCTAssertNotNil(carouselView!.timer)
        XCTAssert(carouselView!.timer.valid)
    }
    
    func testsSetImageUrls() {
        let newImageUrls = [
            "http://api.anotherApp.com/image1.jpg",
            "http://api.anotherApp.com/image2.jpg"
        ]
        
        carouselView!.imageUrls = newImageUrls
        XCTAssertEqual(newImageUrls.count, carouselView!.pageControl!.numberOfPages)
        
        let w = self.view.frame.width
        
        // width should be images.count + 1, for circular scroll
        let content_width = w * CGFloat(newImageUrls.count + 1)
        XCTAssertEqual(content_width, carouselView!.scrollView!.contentSize.width)
    }
    
    //    func testDeinit() {
    //        weak var timer = carouselView!.timer
    //        self.carouselView = nil
    //
    //        XCTAssertNotNil(timer)
    //        XCTAssert(timer?.valid == false)
    //
    //    }
}
