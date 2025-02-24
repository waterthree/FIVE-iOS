//
//  SettingsView.swift
//  FIVE
//
//  Created by Jianmiao Cai on 2/24/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("rssURLs") private var rssURLs: String = ""
    @AppStorage("fetchLimit") private var fetchLimit: Int = 10
    
    // Split the comma-separated RSS URLs into an array
    private var rssURLArray: [String] {
        rssURLs.components(separatedBy: ",").filter { !$0.isEmpty }
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Section for managing RSS URLs
                Section(header: Text("RSS Feeds")) {
                    ForEach(rssURLArray, id: \.self) { url in
                        Text(url)
                    }
                    .onDelete(perform: deleteURL)
                    
                    // Add new URL button
                    Button(action: addURL) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add RSS Feed URL")
                        }
                    }
                }
                
                // Section for setting the fetch limit
                Section(header: Text("Fetch Limit")) {
                    Stepper("Limit: \(fetchLimit)", value: $fetchLimit, in: 1...20)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                // Edit button for deleting URLs
                EditButton()
            }
        }
    }
    
    // Function to add a new RSS URL
    private func addURL() {
        // Show an alert to input a new URL
        let alert = UIAlertController(title: "Add RSS Feed URL", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter RSS Feed URL"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            if let newURL = alert.textFields?.first?.text, !newURL.isEmpty {
                // Append the new URL to the list
                if rssURLs.isEmpty {
                    rssURLs = newURL
                } else {
                    rssURLs += ",\(newURL)"
                }
            }
        })
        
        // Present the alert
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
    
    // Function to delete an RSS URL
    private func deleteURL(at offsets: IndexSet) {
        var updatedURLs = rssURLArray
        updatedURLs.remove(atOffsets: offsets)
        rssURLs = updatedURLs.joined(separator: ",")
    }
}
