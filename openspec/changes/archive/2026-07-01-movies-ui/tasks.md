## 1. Popular Movies — Provider

- [x] 1.1 Create `features/movies/presentation/providers/popular_movies_provider.dart` with AsyncNotifier managing page state and movie list accumulation
- [x] 1.2 Implement loadNextPage logic with guard against duplicate loads and end-of-list detection
- [x] 1.3 Write unit tests for popular movies provider

## 2. Top Rated Movies — Provider

- [x] 2.1 Create `features/movies/presentation/providers/top_rated_movies_provider.dart` with AsyncNotifier managing page state
- [x] 2.2 Implement loadNextPage logic
- [x] 2.3 Write unit tests for top-rated movies provider

## 3. Movie Details — Provider

- [x] 3.1 Create `features/movies/presentation/providers/movie_details_provider.dart` with FutureProvider.family keyed by movie ID
- [x] 3.2 Write unit tests for movie details provider

## 4. Movie Card Widget

- [x] 4.1 Create `features/movies/presentation/widgets/movie_card.dart` displaying poster, title, and rating

## 5. Movie List Screen (Popular + Top Rated)

- [x] 5.1 Create `features/movies/presentation/screens/movie_list_screen.dart` with TabBar and TabBarView
- [x] 5.2 Implement responsive grid layout (2 columns phone, 4+ columns tablet)
- [x] 5.3 Implement infinite scroll via ScrollController listener
- [x] 5.4 Integrate LoadingView, ErrorView, EmptyView for each tab

## 6. Movie Detail Screen

- [x] 6.1 Create `features/movies/presentation/screens/movie_detail_screen.dart` receiving movie ID
- [x] 6.2 Display backdrop image, poster, title, release date, vote average, genres, overview, runtime
- [x] 6.3 Integrate LoadingView and ErrorView states
