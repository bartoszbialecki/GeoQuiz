//
//  Game.swift
//  GeoQuiz
//
//  Created by Bartosz Bialecki on 29/03/2020.
//  Copyright © 2020 Bartosz Bialecki. All rights reserved.
//

import Foundation

class Game: ObservableObject {
    //
    // MARK: - Properties
    //
    
    let maxQuestionsToShow = 10
    
    private var questions = [Country]()
    private var attempt = 0
    private var showingCorrectAnswer = false
    
    @Published var score = 0
    @Published var questionToShow = ""
    @Published var randomAnswerToShow = ""
    
    //
    // MARK: - Init
    //
    
    init() {
        generateQuestions()
    }
    
    //
    // MARK: - Public Methods
    //
    
    func startGame() {
        questions = questions.shuffled()
        generateQuestionAndRandomAnswer()
    }
    
    func resetGame() {
        score = 0
        attempt = 0
        questionToShow = ""
        randomAnswerToShow = ""
        
        startGame()
    }
    
    func done() -> Bool {
        return attempt >= maxQuestionsToShow || attempt >= questions.count
    }
    
    func play(guess: Bool) -> Bool {
        var correct = false
        
        if guess == showingCorrectAnswer {
            score += 1
            correct = true
        }
        
        attempt += 1
        
        return correct
    }
    
    func generateQuestionAndRandomAnswer() {
        if done() {
            return
        }
        
        questionToShow = questions[attempt].countryName
        randomAnswerToShow = generateRandomAnswer()
        showingCorrectAnswer = randomAnswerToShow == questions[attempt].capital!
    }
    
    //
    // MARK: - Private Methods
    //
    
    private func generateRandomAnswer() -> String {
        var randomAnswers: [String] = [questions[attempt].capital!]
        
        for _ in 1...2 {
            randomAnswers.append(questions[generateRandomQuestionIndex()].capital!)
        }
        
        return randomAnswers.randomElement()!
    }
    
    private func generateRandomQuestionIndex() -> Int {
        return Int.random(in: 0..<self.questions.count)
    }
    
    private func generateQuestions() {
        guard let fileURL = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let countries = try JSONDecoder().decode([Country].self, from: jsonData)
            questions = countries.filter({ (country) -> Bool in
                return country.capital != nil
            })
        } catch {
            print(error)
        }
    }
}
