//
//  Sample.swift
//  LocalPackage
//
//  Created by 樋川大聖 on 2025/02/26.
//

/// xが`Sendable`, Sも`Sendable`であれば、`unsafe`ではない。そのため`unsafe`なくても書けるようにすべきという内容のはず。
/// だけど、`unsafe`がなくても元々エラーにならない。Swiftのバージョンの問題かな
///
@MainActor struct S1 {
    nonisolated(unsafe) var x: Int = 0
}

extension S1: Equatable {
    static nonisolated func ==(lhs: S1, rhs: S1) -> Bool {
        return lhs.x == rhs.x
    }
}

/// xが`Sendable`であれば、は暗黙的にmodule内で`noisolated`になる。今まではletだけ。今後はvarも。
///
@MainActor
struct S2 {
    var x: Int = 0 // okay ('nonisolated' is inferred within the module)
}

extension S2: Equatable {
    static nonisolated func ==(lhs: S2, rhs: S2) -> Bool {
        return lhs.x == rhs.x // okay
    }
}

@propertyWrapper
struct MyWrapper<T> {
    var wrappedValue: T
}
@MainActor
struct S3 {
    @MyWrapper var x: Int = 0
}

/// errorになるのでコメントアウトしておく

//extension S3: Equatable {
//    static nonisolated func ==(lhs: S3, rhs: S3) -> Bool {
//        return lhs.x == rhs.x // wrapperd propertyはまだnonisolatedにならないのでエラーになる
//    }
//}
/// feature導入以前は
/// MainActorであるということはSendableなはずだが、
/// Passing closure as a 'sending' parameter risks causing data races between code in the current task and concurrent execution of the closure; this is an error in the Swift 6 language mode
/// というwarningが出る
func test(globallyIsolated: @escaping @MainActor () -> Void) {
    Task {
        // error: capture of 'globallyIsolated' with non-sendable type '@MainActor () -> Void' in a `@Sendable` closure
        await globallyIsolated()
    }
}

class NonSendable {
    var num: Int = 0
    func test() {}
}

func test() async {
    let ns = NonSendable()
    let closure = { @MainActor in
        print(ns)
    }

    Task {
        // このクロージャも暗黙的に @Sendable として扱われるためエラーにならなくなる
        await closure() // okay
    }
}

func test(ns: NonSendable) async {
    let closure = { @MainActor in
        print(ns) // error: task-isolated value 'ns' can't become isolated to the main actor
    }

    await closure()
}

@MainActor
class IsolatedSubclass: NonSendable {
    var mutable = 0
    override func test() {
        super.test()
        /// errorになるのでコメントアウトしておく
//        mutable += 0 // error: Main actor-isolated property 'mutable' can not be referenced from a non-isolated context
    }
    func trySendableCapture() {
        // 元々warningになる？Sendableだったらならないはずなんだけど。
        Task.detached {
            self.test() // error: Capture of 'self' with non-sendable type 'IsolatedSubclass' in a `@Sendable` closure
        }
    }
}
