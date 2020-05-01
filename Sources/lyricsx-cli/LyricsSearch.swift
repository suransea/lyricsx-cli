import ArgumentParser
import LyricsService
import CXExtensions

enum LyricsFormat: String, CaseIterable {
    case lrcx
    case lrc
}

struct LyricsSearch: ParsableCommand {
    
    static var configuration = CommandConfiguration(commandName: "search", abstract: "search lyrics from the internet")
    
    @Argument()
    var keyword: String
    
    @Flag(default: .lrcx)
    var format: LyricsFormat
    
    func run() throws {
        let provider = LyricsProviderManager()
        let req = LyricsSearchRequest(searchTerm: .keyword(keyword), title: "", artist: "", duration: 0)
        guard let lrc = provider.lyricsPublisher(request: req).blocking().next() else {
            print("lyrics not found")
            return
        }
        print(format == .lrcx ? lrc.description : lrc.legacyDescription)
    }
}
