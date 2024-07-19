import SwiftUI

struct NamespaceKey: EnvironmentKey {
    static let defaultValue: Namespace.ID? = nil
}

extension EnvironmentValues {
    var namespace: Namespace.ID? {
        get { self[NamespaceKey.self] }
        set { self[NamespaceKey.self] = newValue }
    }
}

extension View {
    func namespace(_ namespace: Namespace.ID?) -> some View {
        environment(\.namespace, namespace)
    }
}
