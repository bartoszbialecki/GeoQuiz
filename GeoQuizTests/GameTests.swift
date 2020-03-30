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

    func testNewQuestionIsGenerated() {
        let firstQuestion = game.questionToShow
        
        game.play(guess: true)
        game.generateQuestionAndRandomAnswer()
        
        XCTAssertTrue(game.questionToShow.count > 0, "Question is empty")
        XCTAssertTrue(game.randomAnswerToShow.count > 0, "Answer is empty")
        XCTAssertNotEqual(game.questionToShow, firstQuestion)
    }
    
    func testGameOverAfterMaxAllowedAttempts() {
        for _ in 1..<game.maxQuestionsToShow {
            game.play(guess: true)
            game.generateQuestionAndRandomAnswer()
            XCTAssertFalse(game.done(), "Game should go on")
        }
        
        game.play(guess: true)
        
        XCTAssertTrue(game.done(), "Game shoule be over")
    }
    
    func testResetGame() {
        XCTAssertEqual(game.score, 0)
        game.play(guess: true)
        game.generateQuestionAndRandomAnswer()
        game.score = 1
        XCTAssertEqual(game.score, 1)
        
        game.resetGame()
        
        XCTAssertEqual(game.score, 0, "Score after reset game should be 0")
    }
}

