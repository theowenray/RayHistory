import SwiftUI

struct HistoryFactCardView: View {
    let fact: HistoryFact

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(fact.title)
                    .font(.title3)
                    .fontWeight(.semibold)

                if let date = fact.date, !date.isEmpty {
                    Text(date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Text(fact.description)
                .font(.body)

            if let url = fact.sourceURL {
                Link("Learn more", destination: url)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.white.opacity(0.3))
        }
    }
}

#Preview {
    HistoryFactCardView(fact: HistoryFact.previewFacts.first!)
        .padding()
        .background(Color.blue)
}
