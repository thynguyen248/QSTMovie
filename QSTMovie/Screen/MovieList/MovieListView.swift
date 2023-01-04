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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.dataSource) { itemViewModel in
                    ZStack {
                        MovieListItemView(itemViewModel: itemViewModel)
                        NavigationLink(destination: NavigationLazyView(
                            MovieDetailView(viewModel: MovieDetailViewModel(movieModel: itemViewModel.model))
                        )) {
                            EmptyView()
                        }
                        .frame(width: 0).opacity(0)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Movies", displayMode: .large)
            .toolbar(content: {
                Button("Sort") {
                    showingOptions = true
                }
                .confirmationDialog("", isPresented: $showingOptions, titleVisibility: .hidden) {
                    ForEach(viewModel.sortTypes, id: \.self) { sortType in
                        Button(sortType.rawValue) {
                            viewModel.sortTypeTrigger.send(sortType)
                        }
                    }
                }
            })
            .onAppear {
                viewModel.loadTrigger.send(())
            }
            .errorAlert(isPresented: Binding<Bool>(
                get: { viewModel.error != nil },
                set: { _ in }
            ), error: viewModel.error)
        }
        .accentColor(.black)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MovieListViewModel()
        MovieListView(viewModel: viewModel)
    }
}
