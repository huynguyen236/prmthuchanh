import 'movie.dart';

final List<Movie> sampleMovies = [
  Movie(
    id: 'm1',
    title: 'Dune: Part Two',
    posterUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    overview: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.6,
    trailers: [
      const Trailer(title: 'Official Trailer #1'),
      const Trailer(title: 'IMAX Sneak Peek'),
    ],
  ),
  Movie(
    id: 'm2',
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
    overview: 'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.',
    genres: ['Action', 'Comedy'],
    rating: 8.3,
    trailers: [
      const Trailer(title: 'Red Band Trailer'),
      const Trailer(title: 'Behind the Scenes'),
    ],
  ),
];