//
//  ContentView.swift
//  FirstAppSwiftUI
//
//  Created by user on 20/06/22.
//

import SwiftUI

struct ContentView: View {
    @State var quote: Text = Text("Chuck norris is handsome")
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                quote.padding()
                    .frame(width: 400, height: 200, alignment: .center)
                    .foregroundColor(.white)
                
                Button("Chuck Joke") {
                    URLSession.shared.fetchData(at: url) { result in
                        switch result {
                        case .success(let chuck):
                            quote = Text(chuck.value.joke)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }.foregroundColor(.cyan)
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





let url = URL(string: "http://api.icndb.com/jokes/random")!

extension URLSession {
  func fetchData(at url: URL, completion: @escaping (Result<ChuckCall, Error>) -> Void) {
    self.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
      }

      if let data = data {
        do {
          let toDos = try JSONDecoder().decode(ChuckCall.self, from: data)
          completion(.success(toDos))
        } catch let decoderError {
          completion(.failure(decoderError))
        }
      }
    }.resume()
  }
}

struct ChuckCall: Codable {
    let type: String
    let value: ChuckValue
}

struct ChuckValue: Codable {
    let id: Int
    let joke: String
}
