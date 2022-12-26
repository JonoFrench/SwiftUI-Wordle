//
//  GameView.swift
//  Wordle
//
//  Created by Jonathan French on 12.10.22.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var manager: UserManager
    
    var body: some View {
        VStack {
            ForEach(Array(manager.wordsArray.enumerated()), id: \.offset) { index, row in
                LetterLine(letterRows: row,gameRow: index)
            }
        }
    }
}

struct LetterLine: View {
    var letterRows : [LetterItem]
    var gameRow : Int
    @EnvironmentObject var manager: UserManager
    var body: some View {
        HStack {
            Spacer()
            ForEach(Array(letterRows.enumerated()), id: \.offset) { index, letter in
                if gameRow >= manager.currentLine {
                    FlipLetter(frontView: frontLetterView(letter: letter, letterPos: index), backView: backLetterView(letter: letter, letterPos: index), index: index, gameRow: gameRow)
                } else {
                    backLetterView(letter: letter,letterPos: index)
                }
            }
            Spacer()
        }.modifier(ShakeEffect(shakes: manager.isNotWord && manager.currentLine == gameRow ? 4 : 0))
            .animation(.default.repeatCount(1, autoreverses: true).speed(0.25), value: manager.isNotWord && manager.currentLine == gameRow)
    }
}

struct backLetterView: View {
    var letter : LetterItem
    var letterPos : Int
    var body: some View {
        GeometryReader { geometry in
            Label (letter.key, image: "")
                .font(.largeTitle)
                .fontWeight(.bold)
                .labelStyle(.titleOnly)
                .frame(width: 50, height: 50,alignment: .center)
                .foregroundColor(.white)
                .background(letter.backgroundColor)
        }.background(letter.backgroundColor)
            .frame(width: 50, height: 50,alignment: .center)
    }
    
}

struct frontLetterView: View {
    var letter : LetterItem
    var letterPos : Int
    var body: some View {
        GeometryReader { geometry in
            Label (letter.key, image: "")
                .font(.largeTitle)
                .fontWeight(.bold)
                .labelStyle(.titleOnly)
                .frame(width: 50, height: 50,alignment: .center)
                .foregroundColor(.white)
                .background(Color(UIColor.lightGray))
        }.background(Color(UIColor.lightGray))
            .frame(width: 50, height: 50,alignment: .center)
    }
    
}

struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -6 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

struct FlipLetter<FrontView: View, BackView: View>: View {
    @EnvironmentObject var manager: UserManager
    
    let frontView: FrontView
    let backView: BackView
    let index: Int
    let gameRow : Int
    
    var body: some View {
        ZStack() {
            frontView
                .modifier(FlipOpacity(percentage: manager.showBack[manager.currentFlip][index] && manager.currentFlip >= gameRow ? 0 : 1))
                .rotation3DEffect(Angle.degrees(manager.showBack[manager.currentFlip][index] && manager.currentFlip >= gameRow ? 180 : 360), axis: (1,0,0))
            backView
                .modifier(FlipOpacity(percentage: manager.showBack[manager.currentFlip][index] && manager.currentFlip >= gameRow ? 1 : 0))
                .rotation3DEffect(Angle.degrees(manager.showBack[manager.currentFlip][index] && manager.currentFlip >= gameRow ? 0 : 180), axis: (1,0,0))
        }.animation(.default.repeatCount(0, autoreverses: false).speed(0.4), value: manager.showBack[gameRow][index] && manager.currentFlip >= gameRow)
    }
}

private struct FlipOpacity: AnimatableModifier {
    var percentage: CGFloat = 0
    
    var animatableData: CGFloat {
        get { percentage }
        set { percentage = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(Double(percentage.rounded()))
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
