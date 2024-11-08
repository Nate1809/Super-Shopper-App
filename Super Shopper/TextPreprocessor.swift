import Foundation
import NaturalLanguage

struct TextPreprocessor {
    /// Preprocesses the input text by lowercasing, removing punctuation (except hyphens),
    /// replacing multiple spaces with a single space, and lemmatizing each word.
    /// - Parameter text: The raw input text.
    /// - Returns: The preprocessed text.
    static func preprocess(text: String) -> String {
        // Step 1: Lowercasing
        let lowercasedText = text.lowercased()
        
        // Step 2: Removing Special Characters Except Hyphens
        let noSpecialCharsText = removeSpecialCharacters(from: lowercasedText)
        
        // Step 3: Replacing Multiple Spaces with a Single Space
        let singleSpacedText = replaceMultipleSpaces(withSingleSpace: noSpecialCharsText)
        
        // Step 4: Lemmatization
        let lemmatizedText = lemmatize(text: singleSpacedText)
        
        return lemmatizedText
    }
    
    /// Removes special characters except hyphens from the text.
    /// - Parameter text: The input text.
    /// - Returns: Text without special characters except hyphens.
    private static func removeSpecialCharacters(from text: String) -> String {
        // Define the allowed characters: lowercase letters, numbers, spaces, and hyphens
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789 -")
        
        // Remove characters not in the allowed set
        let filteredText = text.unicodeScalars.filter { allowedCharacterSet.contains($0) }
        return String(String.UnicodeScalarView(filteredText))
    }
    
    /// Replaces multiple consecutive spaces with a single space.
    /// - Parameter text: The input text.
    /// - Returns: Text with single spaces.
    private static func replaceMultipleSpaces(withSingleSpace text: String) -> String {
        return text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression).trimmingCharacters(in: .whitespaces)
    }
    
    /// Lemmatizes each word in the text.
    /// - Parameter text: The input text.
    /// - Returns: Lemmatized text.
    private static func lemmatize(text: String) -> String {
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = text
        
        var lemmatizedWords: [String] = []
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, tokenRange in
            if let lemma = tag?.rawValue {
                lemmatizedWords.append(lemma)
            } else {
                // If lemma not found, use the original word
                let word = String(text[tokenRange])
                lemmatizedWords.append(word)
            }
            return true
        }
        
        return lemmatizedWords.joined(separator: " ")
    }
}
