import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var currentNumber: Int = Int.random(in: 2...100)
    @State private var correctAnswers: Int = 0
    @State private var wrongAnswers: Int = 0
    @State private var totalAttempts: Int = 0
    
    @State private var showResult: Bool = false
    @State private var isCorrectSelection: Bool = false
    
    @State private var showSummaryDialog: Bool = false
    
    @State private var timeRemaining: Int = 5
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Prime Number Game")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
            
            Text("Time Left: \(timeRemaining)s")
                .font(.title2)
                .foregroundColor(.blue)
            
            Text("\(currentNumber)")
                .font(.system(size: 70, weight: .bold))
                .frame(width: 180, height: 180)
                .background(Color.orange.opacity(0.2))
                .cornerRadius(20)
            
            if showResult {
                Image(systemName: isCorrectSelection ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(isCorrectSelection ? .green : .red)
            }
            
            HStack(spacing: 30) {
                Button(action: {
                    checkAnswer(userThinksPrime: true)
                }) {
                    Text("Prime")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(width: 130, height: 55)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    checkAnswer(userThinksPrime: false)
                }) {
                    Text("Not Prime")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(width: 130, height: 55)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            
            VStack(spacing: 10) {
                Text("Correct: \(correctAnswers)")
                    .font(.title3)
                    .foregroundColor(.green)
                
                Text("Wrong: \(wrongAnswers)")
                    .font(.title3)
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
        .onReceive(timer) { _ in
            handleTimerTick()
        }
        .alert("10 Attempts Completed", isPresented: $showSummaryDialog) {
            Button("OK") {
                nextRound()
            }
        } message: {
            Text("Correct Answers: \(correctAnswers)\nWrong Answers: \(wrongAnswers)")
        }
    }
    
    //Timer Logic
    func handleTimerTick() {
        if timeRemaining > 1 {
            timeRemaining -= 1
        } else {
            // User did not answer in time, count as wrong
            wrongAnswers += 1
            totalAttempts += 1
            isCorrectSelection = false
            showResult = true
            
            if totalAttempts % 10 == 0 {
                showSummaryDialog = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    nextRound()
                }
            }
        }
    }
    
    //Check User Answer
    func checkAnswer(userThinksPrime: Bool) {
        let actualPrime = isPrime(currentNumber)
        
        if userThinksPrime == actualPrime {
            correctAnswers += 1
            isCorrectSelection = true
        } else {
            wrongAnswers += 1
            isCorrectSelection = false
        }
        
        totalAttempts += 1
        showResult = true
        
        if totalAttempts % 10 == 0 {
            showSummaryDialog = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                nextRound()
            }
        }
    }
    
    //Next Round
    func nextRound() {
        currentNumber = Int.random(in: 2...100)
        timeRemaining = 5
        showResult = false
    }
    
    // Prime Check Function
    func isPrime(_ number: Int) -> Bool {
        if number < 2 { return false }
        if number == 2 { return true }
        if number % 2 == 0 { return false }
        
        let maxDivisor = Int(Double(number).squareRoot())
        
        for i in stride(from: 3, through: maxDivisor, by: 2) {
            if number % i == 0 {
                return false
            }
        }
        
        return true
    }
}

#Preview {
    ContentView()
}
