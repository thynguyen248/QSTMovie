//
//  MovieListView.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/2/23.
//

import SwiftUI
import Combine

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    @State private var showingOptions = false
    @State private var selection = "None"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.dataSource) { itemViewModel in
                    MovieListItemView(itemViewModel: itemViewModel)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Movies", displayMode: .large)
            .toolbar(content: {
                Button("Sort") {
                    showingOptions = true
                }
                .confirmationDialog("Select sort type", isPresented: $showingOptions, titleVisibility: .visible) {
                    ForEach(viewModel.sortTypes, id: \.self) { sortType in
                        Button(sortType.rawValue) {
                            viewModel.sortTypeTrigger.send(sortType)
                        }
                    }
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        .onAppear {
            viewModel.loadTrigger.send(())
        }
    }
}
