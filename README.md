# MovieFinder

Use MovieFinder to find trending movies, search for a movie and find where to watch them!

The app is writen in swift and uses the following third party libraries:
  - [Alamofire](https://github.com/Alamofire/Alamofire), for net working.
  - [Kingfisher](https://github.com/onevcat/Kingfisher), for downloading images from the web. 

MovieFinder uses [The Movie Database API](https://www.themoviedb.org/) as source for all the movie info and poster images.

In order to run it you will have to create an API key from The Movie Database and save it locally in a file as follows:
```
struct ApiKeys {

  let tmdbKey: String = "<your_api_key>"
  
  }
  ```
  Be sure to save it inside the Helpers folder.
  
  
