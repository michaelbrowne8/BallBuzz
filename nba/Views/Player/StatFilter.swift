//
//  StatFilter.swift
//  nba
//
//  Created by Michael Browne on 4/27/23.
//

import SwiftUI

struct StatFilter: View {
    let label: String
    @Binding var statBound: Double
    @Binding var statBoundIsMin: Bool
    let sliderMin: Int
    let sliderMax: Int
    
    var body: some View {
        VStack {
            HStack{
                Text("\(label):")
                
                Slider(value: $statBound, in: Double(sliderMin)...Double(sliderMax), step: 1) {
                    Text("")
                } minimumValueLabel: {
                    Text(String(sliderMin))
                } maximumValueLabel: {
                    Text(String(sliderMax))
                }
            }
            HStack {
                Toggle(isOn: $statBoundIsMin) {
                    if statBoundIsMin {
                        Text("Selecting Minimum")
                    } else {
                        Text("Selecting Maximum")
                    }
                }
                
                if statBoundIsMin {
                    Text("Filter: Minimum \(statBound, specifier: "%.0f")")
                } else {
                    Text("Filter: Maximum \(statBound, specifier: "%.0f")")
                }
            }
        }
        .padding()
        .border(.black)
    }
}
