//
//  CountPickerView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 22.03.24.
//

import SwiftUI

//MARK: - CountPickerView

struct CountPickerView: View {
    
    //MARK: - Properties
    
    @ObservedObject var viewModel: CountDownViewModel
    @State private var hoursIndex = 0
    @State private var minsIndex = 0
    @State private var secsIndex = 0
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    Button(action: { viewModel.dismissPickerSheet() }, label: {
                                Image(systemName: "xmark")
                                    .resizable().frame(width: 12, height: 12)
                                    .font(Font.title.weight(.bold))
                           })
                        .frame(width: 32, height: 32).foregroundColor(Color.white)
                        .background(Color.red).cornerRadius(25)
                        Spacer()
                }.padding(.top, 10)
                
                HStack(alignment: .center, spacing: 16) {
                    GenPickerView(label: "Hours", values: 0...24, index: $hoursIndex)
                    GenPickerView(label: "Minutes", values: 0...60, index: $minsIndex)
                    GenPickerView(label: "Seconds", values: 0...60, index: $secsIndex)
                }
                Button(action: { viewModel.startTimerButt(hours: hoursIndex, mins: minsIndex, secs: secsIndex) },
                       label: { Image(systemName: "arrowtriangle.right.fill").resizable().frame(width: 14, height: 18) })
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.blue).cornerRadius(25)
                    .padding(.bottom, 100)
            }
            .padding(16).frame(maxWidth: .infinity)
            .background(Color.customBackgroundColor)
            .cornerRadius(32)
        }.edgesIgnoringSafeArea(.bottom)
    }
}

//MARK: - GenPickerView

struct GenPickerView: View {
    
    //MARK: Properties
    
    var label: String
    let values: ClosedRange<Int>
    @Binding var index: Int
    
    //MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(Color.blue)
            Picker(selection: $index, label: Text("")) {
                ForEach(values, id: \.self) { i in
                    Text("\(i)")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white)
                        .frame(width: 35)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: 100)
            .clipped()
        }
    }
}




