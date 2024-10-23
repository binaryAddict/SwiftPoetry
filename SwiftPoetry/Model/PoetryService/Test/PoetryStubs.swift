//
//  PoetryStubs.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import Foundation

enum PoetryStubs {
    static let authorJonathanSwift = "Jonathan Swift"
    
    static let authors = [String].readTestJSONFile("Offline/Authors")
    static let jonathanSwiftPoems = [Poem].readTestJSONFile("Offline/Poems/Jonathan Swift")
    static let johnMcCraePoems = [Poem].readTestJSONFile("Offline/Poems/John McCrae")
    static let williamShakespearePoems = [Poem].readTestJSONFile("Offline/Poems/William Shakespeare")
    
    static let shortListOfPoems = johnMcCraePoems
    static let longListOfPoems = williamShakespearePoems
    static let listOfPoemsWithLongPoem = jonathanSwiftPoems
    
    static let longPoem = listOfPoemsWithLongPoem[1]
    static let shortPoem = shortListOfPoems[0]
    
    static let veryShortPoem = Poem(title: "Nothing", author: "Nobody", lines: ["The End."])
}
