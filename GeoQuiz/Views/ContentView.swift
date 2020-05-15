//
//  ContentView.swift
//  GeoQuiz
//
//  Created by Bartosz Bialecki on 29/03/2020.
//  Copyright © 2020 Bartosz Bialecki. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var game: Game
    
    @State private var showGameOver = false
    @State private var showQuestion = true
    @State private var showAnswerInfo = false
    @State private var correctAnswer = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    HStack {
                        Spacer()
                        Text("Score: \(self.game.score)")
                            .transition(.scale)
                            .accessibility(identifier: "score")
                    }
                    .padding()
                    .padding(.bottom, 20)
                    
                    Text("Is the capital of this country correct?")
                        .font(.system(size: 20))
                        .padding(.bottom, 50)
                    
                    Text(self.game.questionToShow)
                        .font(.system(size: 32))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.bottom, 50)
                        .foregroundColor(.blue)
                        .animation(.default)
                        .offset(x: self.showQuestion ? 0 : -geometry.size.width)
                        .opacity(self.showQuestion ? 1 : 0)
                        .accessibility(identifier: "question")
                    
                    Text(self.game.randomAnswerToShow)
                        .font(.system(size: 42))
                        .foregroundColor(Color(UIColor.systemIndigo))
                        .animation(.default)
                        .offset(x: self.showQuestion ? 0 : geometry.size.width)
                        .accessibility(identifier: "answer")
                    
                    Spacer()
                    
                    if self.showAnswerInfo {
                        if self.correctAnswer {
                            Text("Correct")
                                .font(.system(size: 28))
                                .foregroundColor(.green)
                                .transition(.opacity)
                                .accessibility(identifier: "correctAnswer")
                        } else {
                            Text("Wrong")
                                .font(.system(size: 28))
                                .foregroundColor(.red)
                                .transition(.opacity)
                                .accessibility(identifier: "wrongAnswer")
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.play(guess: false)
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 80))
                        }
                        .accessibility(identifier: "noButton")
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.play(guess: true)
                            }
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 80))
                        }
                        .accessibility(identifier: "yesButton")
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                }
                .padding()
                .navigationBarTitle(Text("Geo Quiz"), displayMode: .inline)
            }
            .alert(isPresented: self.$showGameOver) {
                Alert(title: Text("Game Over"),
                      message: Text("Your score is \(self.game.score)"),
                      primaryButton: .default(Text("Start New Game")) {
                        withAnimation {
                            self.game.resetGame()
                        }
                    }, secondaryButton: .cancel())
            }
        }
        .onAppear() {
            self.game.startGame()
        }
    }
    
    func play(guess: Bool) {
        self.showQuestion = false
        correctAnswer = game.play(guess: guess)
        self.showAnswerInfo = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.game.generateQuestionAndRandomAnswer()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                withAnimation {
                    self.showAnswerInfo = false
                    self.correctAnswer = false
                    self.showQuestion = true
                }
                
            }
        }
        
        if game.done() {
            showGameOver = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Game())
    }
}
