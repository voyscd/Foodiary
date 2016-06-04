//
//  FoodiaryTests.swift
//  FoodiaryTests
//
//  Created by wjw on 4/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import XCTest
import Firebase
import Fusuma
@testable import Foodiary

class FoodiaryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLogin() {
        
        let email = "roy@monash.com"
        let password = "12345"
        
        FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in

            
        })
    }
    
    func testSignup() {
        
        let email = "roy@monash.com"
        let password = "12345"
        
        FIREBASE_REF.createUser(email, password: password, withValueCompletionBlock: { (error, authData) -> Void in
            
        })
    }
    
    func testConvertImageToBase64(image: UIImage) -> String{
        let imageData = UIImagePNGRepresentation(UIImage(named: "DefaultFood100")!)
        let base64String = imageData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)        
        return base64String!
    }
    
}
