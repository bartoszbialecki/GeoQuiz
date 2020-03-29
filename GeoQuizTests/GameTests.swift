//
//  GameTests.swift
//  GeoQuizTests
//
//  Created by Bartosz Bialecki on 30/03/2020.
//  Copyright © 2020 Bartosz Bialecki. All rights reserved.
//

import XCTest
@testable import GeoQuiz

class GameTests: XCTestCase {
    var game: Game!
    
    override func setUp() {
        game = Game()
        game.startGame()
    }

    override func tearDown() {
        game = nil
    }

    func testFirstQuestionIsLoaded() {
        XCTAssertTrue(game.questionToShow.count > 0, "Question is empty")
        XCTAssertTrue(game.randomAnswerToShow.count > 0, "Answer is empty")
        XCTAssertEqual(game.score, 0, "Score is 0")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

