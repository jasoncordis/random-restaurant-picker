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

String yelpTest = """
  query SearchRestaurants(\$location: String!) {
    search(term: "restaurants",
            location: "\$location",
            limit: 1) {
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
