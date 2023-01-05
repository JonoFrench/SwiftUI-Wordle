//
//  StatsView.swift
//  Wordle
//
//  Created by Jonathan French on 20.10.22.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var manager: UserManager
    @Environment(\.colorScheme) var colorScheme
    @State var showSheet = false

    var body: some View {
        ZStack {
            closeButton
            VStack {
                Spacer()
                Text("STATISTICS")
                Spacer()
                if let player = manager.playerStats {
                    let winPercent = manager.gamesPlayed > 0 ? Int(((manager.gamesPlayed.floatValue() - player.lostGames.floatValue()) / manager.gamesPlayed.floatValue()) * 100) : 0
                    
                    HStack{
                        Spacer()
                        statBox(title: "Played", stat: "\(manager.gamesPlayed)")
                        Spacer()
                        statBox(title: "Win %", stat: "\(winPercent)")
                        Spacer()
                        statBox(title: "Current Streak", stat: "\(player.currentStreak)")
                        Spacer()
                        statBox(title: "Max Streak", stat: "\(player.maxStreak)")
                        Spacer()
                    }
                    Spacer()
                }
                Text("GUESS DISTRIBUTION")
                VStack {
                    ForEach(0...5, id: \.self) { item in
                        let percent = manager.gamesPlayed > 0 ? Int((manager.gameStats[item].floatValue() / manager.gamesPlayed.floatValue()) * 100) : 0
                        HBarView(row: item + 1, value: manager.gameStats[item], percent: percent, currentLine: manager.currentLine, winner: manager.winner)
                    }
                }
                .frame(height:350,alignment: .top)
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        print("Share button was tapped")
                        self.showSheet.toggle()
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }.buttonStyle(.borderedProminent)
                        .tint(.green)
                        .sheet(isPresented: $showSheet) {
                            ActivityView(text:manager.textExport() , showing: self.$showSheet)
                        }
                    Spacer()
                    Button {
                        manager.reset()
                        manager.showingStats = false
                    } label: {
                        Label("Play Again", systemImage: "")
                    }.buttonStyle(.borderedProminent)
                        .tint(.red)
                    Spacer()
                }
                Spacer()
            }.onAppear{
            }
        }
    }
    
    fileprivate func statBox(title:String, stat:String) -> VStack<TupleView<(Text, Text)>> {
        return VStack{
            Text(stat).font(.system(size: 30))
            Text(title).font(.system(size: 10))
        }
    }
    
    struct HBarView: View {
        var row:Int
        var value: Int
        var percent: Int
        var currentLine: Int
        var winner: Bool
        
        var body: some View {
            GeometryReader { gr in
                let padHeight = gr.size.height * 0.07
                let fullChartWidth = gr.size.width
                let maxTickWidth = fullChartWidth * 0.80
                let scaleFactor = maxTickWidth
                Spacer()
                VStack {
                    Spacer()
                        .frame(height:padHeight)
                    
                    let barSize = (CGFloat(percent)/100) * scaleFactor + 20.0
                    
                    HStack(spacing: 0) {
                        Text("\(row)")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .padding()
                        RoundedRectangle(cornerRadius:5.0)
                            .fill(currentLine + 1 == row && winner ? Color.green : Color.gray)
                            .frame(width: CGFloat(barSize), alignment: .trailing)
                            .overlay(
                                Text("\(value)")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .offset(x:value == 0 ? -6: -10, y:0)
                                ,
                                alignment: .trailing
                            )
                        Spacer()
                    }
                    Spacer()
                        .frame(height:padHeight)
                }
            }
        }
    }
    
    var closeButton: some View {
       VStack {
            HStack {
                Spacer()
                Button(action: {
                    manager.showingStats = false
                }) {
                    Image(systemName: "xmark.circle")
                        .padding(10)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
            .padding(.top, 5)
            Spacer()
        }
    }
    
    struct ActivityView: UIViewControllerRepresentable {
        var text: String
        @Binding var showing: Bool

        func makeUIViewController(context: Context) -> UIActivityViewController {
            let vc = UIActivityViewController(
                activityItems: [text],
                applicationActivities: nil
            )
            vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                self.showing = false
            }
            return vc
        }

        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        }
    }
    
}

//struct StatsView_Previews: PreviewProvider {
//    @Binding var showingStats: Bool
//    static var previews: some View {
//        StatsView(showingStats: true)
//    }
//}
