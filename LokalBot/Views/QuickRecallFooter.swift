import SwiftUI

struct QuickRecallFooter: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.colorSchemeContrast) private var contrast

    let query: String
    let inference: InferencePresentation
    let hasResults: Bool
    let isSearching: Bool
    let ask: () -> Void

    private var accent: Color {
        colorScheme == .dark ? Brand.tealBright : Brand.teal
    }

    var body: some View {
        HStack(spacing: 16) {
            if hasResults {
                HStack(spacing: 12) {
                    Text("↑↓ Navigate")
                    Text("↩ Open")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .accessibilityLabel("Use the arrow keys to navigate and Return to open a result")
            }
            Spacer(minLength: 0)
            if !query.isEmpty {
                VStack(alignment: .trailing, spacing: 4) {
                    Button(action: ask) {
                        HStack(spacing: 7) {
                            Image(systemName: "sparkles")
                            Text("Ask about “\(query)”")
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Text("⌘↩")
                                .font(.caption.monospaced())
                                .padding(.leading, 3)
                        }
                        .font(.callout.weight(.medium))
                        .foregroundStyle(isSearching ? Color.secondary : accent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(accent.opacity(0.10),
                                    in: RoundedRectangle(cornerRadius: Brand.Radius.tab))
                        .overlay {
                            RoundedRectangle(cornerRadius: Brand.Radius.tab)
                                .strokeBorder(accent.opacity(contrast == .increased ? 0.7 : 0.25))
                        }
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(.return, modifiers: .command)
                    .disabled(isSearching)
                    .accessibilityIdentifier("quickRecall.ask")
                    .help("Open Ask with this query and its matching sources")
                    Label(inference.label, systemImage: inference.icon)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .help(inference.detail(
                            local: "Ask uses a model on this Mac.",
                            remote: "Ask uses your configured remote model."))
                }
                .frame(maxWidth: 350, alignment: .trailing)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .frame(minHeight: 42)
    }
}
