class RtTop100MoviesCliApp::CLI

  def call
    puts ""
    puts "********* Best of Rotten Tomatoes: TOP 100 MOVIES OF ALL TIME *********"
    puts ""
    puts "Welcome cinephile! Which of Rotten Tomatoes' Top 100 Movies would you like to see?"
    create_movies
    add_movie_details
    start
  end

  def create_movies
    movies_hash = RtTop100MoviesCliApp::Scraper.scrape_top_100("https://www.rottentomatoes.com/top/bestofrt")
    RtTop100MoviesCliApp::Movie.create_from_collection(movies_hash)
  end

  def add_movie_details
    RtTop100MoviesCliApp::Movie.all.each do | movie |
      details_hash = RtTop100MoviesCliApp::Scraper.scrape_movie("https://www.rottentomatoes.com/top/bestofrt" + movie.movie_url)
      movie.add_details(details_hash)
    end
  end

  def start
    puts ""
    puts "Please enter '1-25', '26-50', '51-75', '76-100', 'methodology', or 'exit':"
    input = gets.strip.downcase

    display_movies(input)

    puts ""
    puts "To learn more about a specific movie, please enter the movie's rank:"
    input = gets.to_i

    selected_movie = RtTop100MoviesCliApp::Movie.all[input-1]

    display_movie_details(selected_movie)

    puts ""
    puts "Would you like to see more movies? Y/N"
    puts ""
    input = gets.strip.downcase
      if input == "y"
        start
      elsif input == "n"
        puts ""
        puts "The End. Thank you!"
        puts ""
        exit
      else
        puts ""
        puts "I'm not quite sure what you meant."
        puts ""
        start
      end
  end

  def display_movies(input)
      if input == "1-25" || input == "26-50" || input == "51-75" || input == "76-100"
        puts ""
        puts "********* Best of Rotten Tomatoes: TOP MOVIES OF ALL TIME #{input} *********"
        puts ""
        list_from = input.to_i
        RtTop100MoviesCliApp::Movie.all[list_from-1, 25].each.with_index(list_from) do | movie, rank |
          puts "#{rank}. #{movie.title}"
        end
      elsif input == "methodology"
        puts ""
        puts "Methodology: Each critic from Rotten Tomatoes' discrete list gets one vote, weighted equally. A movie must have 40 or more rated reviews to be considered. The 'Adjusted Score' comes from a weighted formula (Bayesian) that we use that accounts for variation in the number of reviews per movie."
        puts ""
      elsif input == "exit"
        puts ""
        puts "The End. Thank you!"
        puts ""
        exit
      else
        puts "I'm not quite sure what you meant."
        start
    end
  end

  def display_movie_details(input)
    if input>=1 && input<=100
      puts ""
      puts "********* Best of Rotten Tomatoes: #{movie.title} *********"
      puts ""
      puts "Title:  #{movie.title}"
      puts ""
      puts "Tomatometer Score: #{movie.tomatometer_score}"
      puts "Audience Score: #{movie.audience_score}"
      puts "Critic Consensus: #{movie.critic_consensus}"
      puts ""
      puts "Rated: #{movie.rating}"
      puts "Genre: #{movie.genre}"
      puts "Released: #{movie.release_date}"
      puts "Directed by: #{movie.director}"
      puts "Synopsis: #{movie.synopsis}"
      puts ""
    else
      puts "I'm not quite sure what you meant."
      start
    end
  end

end
