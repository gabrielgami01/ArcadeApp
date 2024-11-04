import Foundation

protocol Pickeable: Hashable, Identifiable, CaseIterable {
    var displayName: String { get }
    var displayImage: String? { get }
}
