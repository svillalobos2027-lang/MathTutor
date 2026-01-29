//
//  ContentView.swift
//  MathTutor
//
//  Created by VILLALOBOS, STEPHANIE on 1/27/26.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    @State private var answer = ""
    @State private var audioplayer: AVAudioPlayer!
    @State private var textFieldIsDisabled = false
    @State private var buttonIsDisabled = false
    @State private var message = ""
    @FocusState private var isFocused: Bool
    
    private let emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    var body: some View {
        VStack {
            Group {
                Text(firstNumberEmojis)
                Text("+")
                Text(secondNumberEmojis)
            }
            .font(Font.system(size: 80))
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .animation(.default, value: message)

            
            Spacer()
            
            Text("\(firstNumber) + \(secondNumber) = ")
                .font(.largeTitle)
                .animation(.default, value: message)
            
            TextField("", text: $answer)
                .font(.largeTitle)
                .frame(width: 60)
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .disabled(textFieldIsDisabled)
            
            Button("Guess") {
                isFocused = false
                guard let answerValue = Int(answer) else {//invalid answer entered
                    return
                }
                if answerValue == firstNumber + secondNumber {
                    playSound(soundName: "correct")
                    message = "Correct!"
                } else {
                    playSound(soundName: "wrong")
                    message = "Sorry, the correct answer is \(firstNumber + secondNumber)"
                }
                textFieldIsDisabled = true
                buttonIsDisabled = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || buttonIsDisabled)
            
            Spacer()
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundStyle(message == "Correct!" ? .green : .red)
                .animation(.default, value: message)
            
            if message != "" {
                Button("Play Again?") {
                    message = ""
                    answer = ""
                    textFieldIsDisabled = false
                    buttonIsDisabled = false
                    generateEquation()
                }
            }
           
        }
        .padding()
        .onAppear{
            generateEquation()
        }
    }
    
    func playSound(soundName: String){
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡ERROR: Could not read file named \(soundName)")
            return
        }
        do {
            audioplayer = try AVAudioPlayer(data: soundFile.data)
            audioplayer.play()
        } catch {
            print("😡ERROR:  \(error.localizedDescription) creating audioPlayer")
        }
    }
    func  generateEquation() {
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        firstNumberEmojis = String(repeating: emojis.randomElement()!, count: firstNumber)
        secondNumberEmojis = String(repeating: emojis.randomElement()!, count: secondNumber)
    }
}

#Preview {
    ContentView()
}
