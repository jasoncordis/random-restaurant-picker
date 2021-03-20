String readRepositories = """
  query ReadRepositories(\$nRepositories: Int!) {
    viewer {
      repositories(last: \$nRepositories) {
        nodes {
          id
          name
          viewerHasStarred
        }
      }
    }
  }
""";

String searchRestaurants = """
  query SearchRestaurants() {
    search(term: "restaurants",
            location: "san francisco",
            limit: 5) {
      total
      business {
        name
        url
        photos
        is_closed
        hours {
          is_open_now
          open {
            start
            end
            day
          }
        }
        distance
        location {
          formatted_address
        }
        coordinates {
          latitude
          longitude
        }
        reviews {
          text
        }
        phone
      }
    }
  }
""";

String yelpTest = """
  query SearchRestaurants() {
    search(term: "restaurants",
            location: "san francisco",
            limit: 5) {
      total
    }
  }
""";
