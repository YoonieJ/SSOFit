//
//  WeekdayPicker.swift
//  SSOFit
//

import SwiftUI

// Seven toggle chips, Monday to Sunday. Values are Calendar weekday numbers (1 is Sunday).
struct WeekdayPicker: View {
    @Binding var selection: Set<Int>

    private let days: [(weekday: Int, label: String)] = [
        (2, "Mon"), (3, "Tue"), (4, "Wed"), (5, "Thu"), (6, "Fri"), (7, "Sat"), (1, "Sun")
    ]

    var body: some View {
        HStack(spacing: 6) {
            ForEach(days, id: \.weekday) { day in
                let isOn = selection.contains(day.weekday)
                Button {
                    if isOn {
                        selection.remove(day.weekday)
                    } else {
                        selection.insert(day.weekday)
                    }
                } label: {
                    Text(day.label)
                        .font(.appCaption)
                        .foregroundStyle(isOn ? Theme.onAccent : Theme.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isOn ? Theme.blush : Theme.surface, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(isOn ? Theme.blush : Theme.divider, lineWidth: 1))
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isOn ? .isSelected : [])
            }
        }
    }
}

#Preview {
    WeekdayPicker(selection: .constant([2, 4]))
        .padding()
}
