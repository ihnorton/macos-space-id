import SwiftUI

struct RenamePopoverView: View {
    let spaceKey: SpaceKey
    let store: SpaceStore
    let dismiss: () -> Void

    @State private var name = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Rename Space").font(.headline)
            TextField("Space name", text: $name)
                .textFieldStyle(.roundedBorder)
                .onSubmit(save)
            HStack {
                Button("Reset") {
                    store.setName("", for: spaceKey)
                    dismiss()
                }
                Spacer()
                Button("Cancel", action: dismiss)
                    .keyboardShortcut(.cancelAction)
                Button("Save", action: save)
                    .buttonStyle(.borderedProminent)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding()
        .onAppear { name = store.name(for: spaceKey) }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        store.setName(trimmed, for: spaceKey)
        dismiss()
    }
}
