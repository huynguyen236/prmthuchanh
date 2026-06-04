import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// ==========================================
// STEP 2: DEFINE THE MOVIE MODEL & MOCK DATA
// ==========================================
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

const List<Movie> allMovies = [
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama', 'Crime'],
    posterUrl: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?q=80&w=400',
    rating: 4.9,
  ),
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=400',
    rating: 4.8,
  ),
  Movie(
    title: 'Spirited Away',
    year: 2001,
    genres: ['Animation', 'Adventure', 'Fantasy'],
    posterUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?q=80&w=400',
    rating: 4.7,
  ),
  Movie(
    title: 'The Godfather',
    year: 1972,
    genres: ['Crime', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1509281373149-e957c6296406?q=80&w=400',
    rating: 4.9,
  ),
  Movie(
    title: 'Pulp Fiction',
    year: 1994,
    genres: ['Crime', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?q=80&w=400',
    rating: 4.6,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=400',
    rating: 4.8,
  ),
];

// All unique genres extracted from mock data
const List<String> availableGenres = [
  'Action',
  'Drama',
  'Crime',
  'Sci-Fi',
  'Thriller',
  'Animation',
  'Adventure',
  'Fantasy'
];

// ==========================================
// STEP 3: BUILD THE BASE APP STRUCTURE
// ==========================================
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({Key? key}) : super(key: key);

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // State variables for tracking UI filters
  String _searchQuery = '';
  final Set<String> _selectedGenres = {};
  String _selectedSort = 'A-Z';

  final List<String> _sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating'];

  // ==========================================
  // STEP 7: FILTER & SORT LOGIC
  // ==========================================
  List<Movie> get _filteredAndSortedMovies {
    // 1. Filtering
    List<Movie> filtered = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesGenre = _selectedGenres.isEmpty || 
          movie.genres.any((genre) => _selectedGenres.contains(genre));

      return matchesSearch && matchesGenre;
    }).toList();

    // 2. Sorting
    switch (_selectedSort) {
      case 'A-Z':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        filtered.sort((a, b) => b.year.compareTo(a.year)); // Newer first
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating)); // Higher first
        break;
    }
    return filtered;
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedGenres.clear();
      _selectedSort = 'A-Z';
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleMovies = _filteredAndSortedMovies;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find a Movie',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // BONUS: Clear filters button with conditional visibility
          if (_searchQuery.isNotEmpty || _selectedGenres.isNotEmpty)
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear_all, color: Colors.redAccent),
              label: const Text('Clear', style: TextStyle(color: Colors.redAccent)),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              // STEP 4: RESPONSIVE SEARCH BAR
              _buildSearchBar(),
              const SizedBox(height: 16),

              // STEP 5 & BONUS: GENRE CHIPS WITH BADGE
              _buildGenreHeader(),
              const SizedBox(height: 8),
              _buildGenreChips(),
              const SizedBox(height: 16),

              // STEP 6: SORT DROPDOWN BAR
              _buildSortBar(visibleMovies.length),
              const SizedBox(height: 12),

              // STEP 8: RESPONSIVE MOVIE LIST AREA
              Expanded(
                child: visibleMovies.isEmpty
                    ? _buildEmptyState()
                    : _buildResponsiveMovieLayout(visibleMovies),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget: Search TextField
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Search movie by title...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // Widget: Genre section title with active filter counter (Bonus)
  Widget _buildGenreHeader() {
    return Row(
      children: [
        const Text(
          'Genres',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        if (_selectedGenres.isNotEmpty) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_selectedGenres.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ]
      ],
    );
  }

  // Widget: Flexible Wrap Layout for Genre Chips
  Widget _buildGenreChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: availableGenres.map((genre) {
        final isSelected = _selectedGenres.contains(genre);
        return FilterChip(
          label: Text(genre),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedGenres.add(genre);
              } else {
                _selectedGenres.remove(genre);
              }
            });
          },
          selectedColor: Colors.deepPurple.withOpacity(0.2),
          checkmarkColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }

  // Widget: Sort Controller Bar
  Widget _buildSortBar(int resultsCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$resultsCount movies found',
          style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
        ),
        Row(
          children: [
            const Text('Sort by: ', style: TextStyle(color: Colors.black54)),
            DropdownButton<String>(
              value: _selectedSort,
              items: _sortOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSort = newValue;
                  });
                }
              },
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
              style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  // Widget: Adaptive layout switcher using LayoutBuilder
  Widget _buildResponsiveMovieLayout(List<Movie> movies) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint rule: Screen Width >= 800 px uses Grid View (2 Columns)
        if (constraints.maxWidth >= 800) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) => MovieCard(movie: movies[index], isTablet: true),
          );
        } else {
          // Standard Phone Layout: 1 Column List View
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: MovieCard(movie: movies[index], isTablet: false),
            ),
          );
        }
      },
    );
  }

  // Widget: Shown when no results match the current filters
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_filter, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No movies match your criteria.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// STEP 8 (CONT) & BONUS: CUSTOM MOVIE CARD
// ==========================================
class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isTablet;

  const MovieCard({
    Key? key,
    required this.movie,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Responsive Poster Dimension handling
          Hero(
            tag: movie.title,
            child: Image.network(
              movie.posterUrl,
              width: isTablet ? 110 : 90,
              height: isTablet ? 160 : 130,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: isTablet ? 110 : 90,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
          
          // Movie Metadata Details Segment
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Year: ${movie.year}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  
                  // Display dynamic horizontal list of tags inside card
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: movie.genres.map((g) {
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(g, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // BONUS: Graphical rating visualization
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toString(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}