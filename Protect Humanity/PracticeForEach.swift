//
//  PracticeForEach.swift
//  Protect_Humanity
//
//  Created by Conner Yoon on 7/24/22.
//

import SwiftUI

struct PracticeForEach: View {
    var body: some View {
        HStack{
            
            ForEach(0..<3, id: \.self){ n in
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                ZStack{
                Rectangle()
                    Text("\(n)").foregroundColor(Color.white)
                }
            
            }
            
        }
    }
}

struct PracticeForEach_Previews: PreviewProvider {
    static var previews: some View {
        PracticeForEach()
    }
}
