import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/api_exercise.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  late Future<List<ApiExercise>> _exerciseFuture;
  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  final List<String> _quickSearches = const [
    'abs',
    'legs',
    'chest',
    'back',
    'glutes',
    'biceps',
    'triceps',
    'shoulders',
    'machine',
    'cable',
  ];

  @override
  void initState() {
    super.initState();
    _exerciseFuture = fetchExercises();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<ApiExercise>> fetchExercises() async {
    final Uri url = Uri.parse(
      'https://oss.exercisedb.dev/api/v1/exercises',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List rawExercises;

      if (decoded is List) {
        rawExercises = decoded;
      } else if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        rawExercises = decoded['data'];
      } else if (decoded is Map<String, dynamic> && decoded['results'] is List) {
        rawExercises = decoded['results'];
      } else {
        rawExercises = [];
      }

      final exercises = rawExercises
          .map(
            (item) => ApiExercise.fromJson(item as Map<String, dynamic>),
      )
          .where((exercise) {
        final hasName = exercise.name.trim().isNotEmpty;
        final hasGif = exercise.gifUrl.trim().isNotEmpty;
        return hasName && hasGif;
      }).toList();

      return exercises;
    } else {
      throw Exception('Failed to load exercises.');
    }
  }

  List<ApiExercise> _filterExercises(List<ApiExercise> exercises) {
    final query = _normalizeSearch(_searchText);

    if (query.isEmpty) {
      return exercises.take(60).toList();
    }

    return exercises.where((exercise) {
      final searchableText = _normalizeSearch(
        '${exercise.name} '
            '${exercise.targetMuscles.join(' ')} '
            '${exercise.bodyParts.join(' ')} '
            '${exercise.equipments.join(' ')} '
            '${exercise.secondaryMuscles.join(' ')}',
      );

      if (searchableText.contains(query)) {
        return true;
      }

      // Helpful aliases so common gym searches work better.
      if (query == 'abs' || query == 'core') {
        return searchableText.contains('abs') ||
            searchableText.contains('abdominals') ||
            searchableText.contains('waist') ||
            searchableText.contains('core');
      }

      if (query == 'legs' || query == 'leg') {
        return searchableText.contains('upper legs') ||
            searchableText.contains('lower legs') ||
            searchableText.contains('quads') ||
            searchableText.contains('quadriceps') ||
            searchableText.contains('hamstrings') ||
            searchableText.contains('calves') ||
            searchableText.contains('glutes');
      }

      if (query == 'arms' || query == 'arm') {
        return searchableText.contains('biceps') ||
            searchableText.contains('triceps') ||
            searchableText.contains('forearms') ||
            searchableText.contains('upper arms');
      }

      if (query == 'shoulders' || query == 'shoulder') {
        return searchableText.contains('delts') ||
            searchableText.contains('deltoids') ||
            searchableText.contains('shoulders');
      }

      return false;
    }).toList();
  }

  String _normalizeSearch(String text) {
    return text.toLowerCase().trim();
  }

  String _formatTitle(String text) {
    return text
        .split(' ')
        .map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    })
        .join(' ');
  }

  void _setQuickSearch(String value) {
    setState(() {
      _searchText = value;
      _searchController.text = value;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchText = '';
      _searchController.clear();
    });
  }

  void _showExerciseDetails(BuildContext context, ApiExercise exercise) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.88,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      exercise.gifUrl,
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 260,
                          width: double.infinity,
                          color: Colors.green.shade50,
                          child: Icon(
                            Icons.fitness_center,
                            size: 72,
                            color: Colors.green.shade700,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _formatTitle(exercise.name),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _InfoChip(
                    icon: Icons.accessibility_new,
                    label: 'Target: ${exercise.targetText}',
                  ),
                  const SizedBox(height: 8),
                  _InfoChip(
                    icon: Icons.fitness_center,
                    label: 'Equipment: ${exercise.equipmentText}',
                  ),
                  const SizedBox(height: 8),
                  _InfoChip(
                    icon: Icons.category_outlined,
                    label: 'Body Part: ${exercise.bodyPartText}',
                  ),
                  const SizedBox(height: 8),
                  _InfoChip(
                    icon: Icons.add_circle_outline,
                    label: 'Secondary: ${exercise.secondaryText}',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    exercise.instructionText,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      'Use this as inspiration when creating your own workout in the Add tab.',
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search abs, legs, chest, cable...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.close),
                )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _quickSearches.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final chip = _quickSearches[index];
                  final selected = _searchText.toLowerCase() == chip;

                  return ChoiceChip(
                    label: Text(chip),
                    selected: selected,
                    onSelected: (_) => _setQuickSearch(chip),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(ApiExercise exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _showExerciseDetails(context, exercise),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  exercise.gifUrl,
                  width: 105,
                  height: 105,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 105,
                      height: 105,
                      color: Colors.green.shade50,
                      child: Icon(
                        Icons.fitness_center,
                        color: Colors.green.shade700,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatTitle(exercise.name),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Target: ${exercise.targetText}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Equipment: ${exercise.equipmentText}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tap for instructions',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ApiExercise>>(
      future: _exerciseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 18),
                Text(
                  'Loading live exercises...',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 72,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Could not load ExerciseDB data.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check your internet connection and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _exerciseFuture = fetchExercises();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        final allExercises = snapshot.data ?? [];
        final filteredExercises = _filterExercises(allExercises);

        return CustomScrollView(
          slivers: [
            _buildSearchHeader(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 10),
                child: Text(
                  _searchText.isEmpty
                      ? 'Showing ${filteredExercises.length} featured exercises'
                      : '${filteredExercises.length} results for "$_searchText"',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (filteredExercises.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 72,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No matching exercises found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching for abs, legs, chest, back, cable, dumbbell, or machine.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return _buildExerciseCard(filteredExercises[index]);
                    },
                    childCount: filteredExercises.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}