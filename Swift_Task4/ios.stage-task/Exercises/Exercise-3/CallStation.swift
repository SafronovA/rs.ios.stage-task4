import Foundation

final class CallStation {
    var usersDB = Set<User>()
    var callsDB = Array<Call>()
}

extension CallStation: Station {
    func users() -> [User] {
        return Array(usersDB)
    }
    
    func add(user: User) {
        usersDB.insert(user)
    }
    
    func remove(user: User) {
        usersDB.remove(user)
        if var call = currentCall(user: user) {
            call.status = .ended(reason: .error)
            updateCall(call)
        }
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case .start(from: let from, to: let to):
            if users().contains(from) || users().contains(to) {
                var call = Call(id: UUID(), incomingUser: to, outgoingUser: from, status: .calling)
                if let _ = callsDB.first(where: { ($0.incomingUser == to || $0.outgoingUser == to) && $0.status == .talk }) {
                    call.status = .ended(reason: .userBusy)
                }
                if !(users().contains(from) && users().contains(to)) {
                    call.status = .ended(reason: .error)
                }
                callsDB.append(call)
                return call.id
            }
        case .answer(from: let from):
            if var answeredCall = callsDB.first(where: { $0.incomingUser == from || $0.outgoingUser == from }) {
                if usersDB.contains(from) {
                    answeredCall.status = .talk
                    updateCall(answeredCall)
                    return answeredCall.id
                }
            }
        case .end(from: let from):
            if var endedCall = callsDB.first(where: { $0.incomingUser == from || $0.outgoingUser == from }) {
                switch endedCall.status {
                case .calling:
                    endedCall.status = .ended(reason: .cancel)
                case .talk:
                    endedCall.status = .ended(reason: .end)
                case .ended(reason: let reason):
                    print(reason)
                }
                updateCall(endedCall)
                return endedCall.id
            }
        }
        return nil
    }
    
    func calls() -> [Call] {
        return callsDB
    }
    
    func calls(user: User) -> [Call] {
        return callsDB.filter({ $0.incomingUser == user || $0.outgoingUser == user })
    }
    
    func call(id: CallID) -> Call? {
        return callsDB.first(where: { $0.id == id })
    }
    
    func currentCall(user: User) -> Call? {
        return callsDB.first(where: {
            ($0.status == .calling || $0.status == .talk) &&
                ($0.incomingUser == user || $0.outgoingUser == user)
        })
    }
    
    private func updateCall(_ call: Call) {
        if let index = calls().firstIndex(where: { $0.id == call.id } ) {
            callsDB.remove(at: index)
            callsDB.insert(call, at: index)
        }
    }
}
