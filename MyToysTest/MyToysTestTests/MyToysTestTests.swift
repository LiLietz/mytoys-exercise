//
//  MyToysTestTests.swift
//  MyToysTestTests
//
//  Created by LiLietz on 11.06.17.
//  Copyright © 2017 LiLietz. All rights reserved.
//

import XCTest
@testable import MyToysTest

class MyToysTestTests: XCTestCase {
    
    var menuTableViewController: MenuTVC!
    
    let json: [String: Any] = [
        "navigationEntries": [[
            "type": "section",
            "label": "Service",
            "children": [[
                "type": "node",
                "label": "Baby & Schwangerschaft",
                "children": [[
                    "type": "link",
                    "label": "Alles von Babymode",
                    "url": "http://www.mytoys.de/"
                    ], [
                        "type": "node",
                        "label": "Kindergarten",
                        "children": [[
                            "type": "link",
                            "label": "13-24 Monate",
                            "url": "http://www.mytoys.de/"
                            ]]
                    ]]
                ]]
            ]]
    ]
    
    override func setUp() {
        super.setUp()
        menuTableViewController = MenuTVC()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        menuTableViewController = nil
    }
    
    func testParseJson() {
        
        // when
        let objects = menuTableViewController.parseJson(json: json)
        
        let section = objects[0]
        
        let firstNode = section.children![0]
        
        let secondLink = firstNode.children![0]
        let secondNode = firstNode.children![1]
        
        let thirdLink = secondNode.children![0]
        
        let sectionType: ModelType = .section
        let nodeType: ModelType = .node
        let linkType: ModelType = .link
        
        
        // then
        
        // test returned array count
        XCTAssertEqual(objects.count, 1, "found: \(objects.count)")
        
        // test section
        XCTAssertEqual(section.type, sectionType, "found: \(section.type)")
        XCTAssertEqual(section.label, "Service", "found: \(section.label)")
        XCTAssertEqual(section.children!.count, 1, "found: \(section.children!.count)")
        
        // test section children
        // node
        XCTAssertEqual(firstNode.type, nodeType, "found: \(firstNode.type)")
        XCTAssertEqual(firstNode.label, "Baby & Schwangerschaft", "found: \(firstNode.label)")
        XCTAssertEqual(firstNode.children!.count, 2, "found: \(firstNode.children!.count)")
        
        // test second layer children
        // link
        XCTAssertEqual(secondLink.type, linkType, "found: \(secondLink.type)")
        XCTAssertEqual(secondLink.label, "Alles von Babymode", "found: \(secondLink.label)")
        XCTAssertNil(secondLink.children)
        //node
        XCTAssertEqual(secondNode.type, nodeType, "found: \(secondNode.type)")
        XCTAssertEqual(secondNode.label, "Kindergarten", "found: \(secondNode.label)")
        XCTAssertEqual(secondNode.children!.count, 1, "found: \(secondNode.children!.count)")
        
        // test third layer child: link
        XCTAssertEqual(thirdLink.type, linkType, "found: \(thirdLink.type)")
        XCTAssertEqual(thirdLink.label, "13-24 Monate", "found: \(thirdLink.label)")
        XCTAssertNil(thirdLink.children)
    }
    
    func testNumberOfSections() {
        
        // 1. given
        menuTableViewController.objects = menuTableViewController.parseJson(json: json)
        let tableView = menuTableViewController.tableView!
        
        // 2. when
        let numberOfSections: Int = menuTableViewController.numberOfSections(in: tableView)
        
        // 3. then
        XCTAssertEqual(numberOfSections, 1, "found: \(numberOfSections)")
    }
    
    func testNumberOfRows() {
        
        // 1. given
        menuTableViewController.objects = menuTableViewController.parseJson(json: json)
        let tableView = menuTableViewController.tableView!
        
        // 2. when
        let numberOfRows = menuTableViewController.tableView(tableView, numberOfRowsInSection: 0)
        
        // 3. then
        XCTAssertEqual(numberOfRows, 1, "found: \(numberOfRows)")

    }
    
    func testHeightForHeader() {
        
        // 1. given
        menuTableViewController.objects = menuTableViewController.parseJson(json: json)
        let tableView = menuTableViewController.tableView!
        
        // 2. when
        let heightForHeader = menuTableViewController.tableView(tableView, heightForHeaderInSection: 0)
        
        // 3. then
        XCTAssertEqual(heightForHeader, 44, "found: \(heightForHeader)")
        
    }
    
    func testViewForHeader() {
        
        // 1. given
        menuTableViewController.objects = menuTableViewController.parseJson(json: json)
        let tableView = menuTableViewController.tableView!
        
        // 2. when
        let viewForHeader = menuTableViewController.tableView(tableView, viewForHeaderInSection: 0)
        
        // 3. then
        XCTAssert(viewForHeader is HeaderCell, "found: \(type(of: viewForHeader))")
    }
    
    func testCellForRow() {
        
        // 1. given
        menuTableViewController.objects = menuTableViewController.parseJson(json: json)
        let tableView = menuTableViewController.tableView!
        
        // 2. when
        let cellForRow = menuTableViewController.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let rightDetail = cellForRow.detailTextLabel!
            
        // 3. then
        XCTAssertFalse(rightDetail.isHidden)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
