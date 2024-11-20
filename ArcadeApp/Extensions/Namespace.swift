import SwiftUI

extension EnvironmentValues {
    @Entry var namespace: Namespace.ID? = nil
}

extension View {
    func namespace(_ namespace: Namespace.ID?) -> some View {
        environment(\.namespace, namespace)
    }
}
