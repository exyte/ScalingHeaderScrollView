//
//  BankingService.swift
//  Example
//
//  Created by Danil Kristalev on 30.12.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation

struct BankTransaction: Identifiable {
    let id = UUID()
    let iconName: String
    let date: Date?
    let title: String
    let category: String
    let balance: Double
    
    static let asosTransaction = BankTransaction(iconName: "Asos", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 29)), title: "ASOS", category: "Сlothes and accessories", balance: -36.67)
    
    static let sevenElevenTransaction1 = BankTransaction(iconName: "SevenEleven", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 26, hour: 13)), title: "Seven Eleven", category: "Store for food", balance: -3.88)
    static let paypalTransaction1 = BankTransaction(iconName: "Paypal", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 26, hour: 12)), title: "PayPal", category: "Internal transfer", balance: 110.94)
    static let goldApple = BankTransaction(iconName: "GoldApple", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 26, hour: 11)), title: "Gold Apple", category: "Cosmetics and perfumery store", balance: -166.24)
    
    static let appStore = BankTransaction(iconName: "AppStore", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 25, hour: 13)), title: "App Store", category: "Online application store", balance: -9.99)
    static let sevenElevenTransaction2 = BankTransaction(iconName: "SevenEleven", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 25, hour: 12)), title: "Seven Eleven", category: "Store for food", balance: -9.66)
    
    static let bookStore = BankTransaction(iconName: "BookStore", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 23, hour: 13)), title: "Book Store", category: "Books store", balance: -12.51)
    static let paypalTransaction2 = BankTransaction(iconName: "Paypal", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 23, hour: 12)), title: "PayPal", category: "Internal transfer", balance: 55.18)
    static let sevenElevenTransaction3 = BankTransaction(iconName: "SevenEleven", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 23, hour: 11)), title: "Seven Eleven", category: "Store for food", balance: -9.66)

    static let asosTransaction2 = BankTransaction(iconName: "Asos", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 29)), title: "ASOS", category: "Сlothes and accessories", balance: -36.67)

    static let sevenElevenTransaction12 = BankTransaction(iconName: "SevenEleven", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 26, hour: 13)), title: "Seven Eleven", category: "Store for food", balance: -3.88)
    static let paypalTransaction12 = BankTransaction(iconName: "Paypal", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 26, hour: 12)), title: "PayPal", category: "Internal transfer", balance: 110.94)
    static let goldApple2 = BankTransaction(iconName: "GoldApple", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 26, hour: 11)), title: "Gold Apple", category: "Cosmetics and perfumery store", balance: -166.24)

    static let appStore2 = BankTransaction(iconName: "AppStore", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 25, hour: 13)), title: "App Store", category: "Online application store", balance: -9.99)
    static let sevenElevenTransaction22 = BankTransaction(iconName: "SevenEleven", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 25, hour: 12)), title: "Seven Eleven", category: "Store for food", balance: -9.66)

    static let bookStore2 = BankTransaction(iconName: "BookStore", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 23, hour: 13)), title: "Book Store", category: "Books store", balance: -12.51)
    static let paypalTransaction22 = BankTransaction(iconName: "Paypal", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 23, hour: 12)), title: "PayPal", category: "Internal transfer", balance: 55.18)
    static let sevenElevenTransaction32 = BankTransaction(iconName: "SevenEleven", date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 23, hour: 11)), title: "Seven Eleven", category: "Store for food", balance: -9.66)
}

struct BankingService {

    let transactions: [BankTransaction] = [.asosTransaction,
                                           .sevenElevenTransaction1, .paypalTransaction1, .goldApple,
                                           .appStore, .sevenElevenTransaction2,
                                           .bookStore, .paypalTransaction2, .sevenElevenTransaction3,
                                           .asosTransaction2,
                                           .sevenElevenTransaction12, .paypalTransaction12, .goldApple2,
                                           .appStore2, .sevenElevenTransaction22,
                                           .bookStore2, .paypalTransaction22, .sevenElevenTransaction32]
}
