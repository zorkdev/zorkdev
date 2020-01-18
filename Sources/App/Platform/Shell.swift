import Vapor

final class Shell: Service {
    private var worker: Container

    init(worker: Container) throws {
        self.worker = worker
    }

    func execute(commandName: String, arguments: [String] = []) throws -> EventLoopFuture<Data> {
        try bash(commandName: commandName, arguments: arguments)
    }

    private func bash(commandName: String, arguments: [String]) throws -> EventLoopFuture<Data> {
        executeShell(command: "/bin/bash", arguments: [ "-l", "-c", "which \(commandName)" ])
            .map(to: String.self) { data in
                guard let commandPath = String(data: data, encoding: .utf8) else {
                    throw Abort(.internalServerError)
                }
                return commandPath.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            }.flatMap(to: Data.self) { path in
                self.executeShell(command: path, arguments: arguments)
            }
    }

    private func executeShell(command: String, arguments: [String] = []) -> EventLoopFuture<Data> {
        EventLoopFuture.map(on: worker) {
            let process = Process()
            process.launchPath = command
            process.arguments = arguments

            let pipe = Pipe()
            process.standardOutput = pipe
            process.launch()

            return pipe.fileHandleForReading.readDataToEndOfFile()
        }
    }
}

extension Shell: ServiceType {
    public static func makeService(for worker: Container) throws -> Shell {
        try Shell(worker: worker)
    }
}
