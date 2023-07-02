//
//  CongratulationsView.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 30/06/23.
//

import SwiftUI
import AVFoundation

// ---------------------------------- @James @Tiff -------------------------------

struct CongratulationsView: View {
    
    @State var Congrats: String = ""
    
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(Congrats)
                .resizable()
                .frame(alignment: .center)
                .onAppear(perform: timerCongrats)
        }.background(BlurView(style: .systemUltraThinMaterialDark)).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20).onAppear {
            let filePath = Bundle.main.path(forResource: "treasureFound", ofType: "mp3")
            let audioNSURL = NSURL(fileURLWithPath: filePath!)
            do { backgroundMusic = try AVAudioPlayer(contentsOf: audioNSURL as URL)}
            catch { return print("Cannot Find The Audio")}
            
            backgroundMusic.numberOfLoops = -1
            backgroundMusic.volume = 0.5
            backgroundMusic.play()
        }
    }
    
    func timerCongrats() {
        var index = 1
        _ = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) {
            (timer) in
            
            Congrats = "congrats\(index)"
            index += 1
            
            if (index > 11){
                index = 1
            }
        }
    }
}

struct CongratulationsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratulationsView().previewInterfaceOrientation(.landscapeLeft)
    }
}


// ---------------------------------- @James @Tiff -------------------------------
// ini background assetnya memang putih dr designer, jd aku ga bisa set bg-nya ke blur.
