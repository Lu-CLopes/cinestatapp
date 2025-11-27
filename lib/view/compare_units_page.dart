// Tela de Filmes
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../service/firebase/data_connect_service.dart';

class _UnitOption {
  const _UnitOption({
    required this.id,
    required this.name,
    required this.capacity,
  });

  final String id;
  final String name;
  final int capacity;
}

class _AudienceMetrics {
  const _AudienceMetrics({
    required this.total,
    required this.averageAge,
    required this.genrePercentages,
    required this.formatPercentages,
  });

  factory _AudienceMetrics.fromEntries(List<Map<String, dynamic>> entries) {
    if (entries.isEmpty) {
      return _AudienceMetrics.empty();
    }

    final total = entries.length;
    final ages = entries
        .map((entry) => entry['age'] as int? ?? 0)
        .where((age) => age > 0)
        .toList();

    final Map<String, int> genreCounts = {};
    final Map<String, int> formatCounts = {};

    for (final entry in entries) {
      final genre = (entry['genre'] as String?)?.trim();
      if (genre != null && genre.isNotEmpty) {
        genreCounts.update(genre, (value) => value + 1, ifAbsent: () => 1);
      }

      final format = (entry['format'] as String?)?.trim();
      if (format != null && format.isNotEmpty) {
        formatCounts.update(format, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    Map<String, double> _toPercentages(Map<String, int> source) {
      if (source.isEmpty || total == 0) return {};
      return source.map(
        (key, value) => MapEntry(key, (value / total) * 100),
      );
    }

    final averageAge = ages.isEmpty
        ? 0.0
        : ages.reduce((value, element) => value + element) / ages.length;

    return _AudienceMetrics(
      total: total,
      averageAge: averageAge,
      genrePercentages: _toPercentages(genreCounts),
      formatPercentages: _toPercentages(formatCounts),
    );
  }

  factory _AudienceMetrics.empty() => const _AudienceMetrics(
        total: 0,
        averageAge: 0,
        genrePercentages: {},
        formatPercentages: {},
      );

  final int total;
  final double averageAge;
  final Map<String, double> genrePercentages;
  final Map<String, double> formatPercentages;
}

class CompareUnitsPage extends StatefulWidget {
  const CompareUnitsPage({super.key});

  @override
  State<CompareUnitsPage> createState() => _CompareUnitsPageState();
}

class _CompareUnitsPageState extends State<CompareUnitsPage> {
  final DataConnectService _service = DataConnectService();

  final List<_UnitOption> _unitOptions = [];
  List<String> _unitNames = [];
  String? _selectedUnit1;
  String? _selectedUnit2;
  bool _isLoading = true;
  bool _isLoadingMetrics = false;

  final Map<String, _AudienceMetrics> _metricsCache = {};

  static const Map<String, double> _fallbackTicketRevenue = {
    'Unidade A': 75,
    'Unidade B': 55,
  };
  static const Map<String, double> _fallbackPopcornRevenue = {
    'Unidade A': 60,
    'Unidade B': 85,
  };
  static const Map<String, double> _fallbackOccupancy = {
    'Unidade A': 70,
    'Unidade B': 90,
  };
  static const Map<String, double> _fallbackGenreChart = {
    'Ação': 65,
    'Comédia': 35,
  };
  static const Map<String, double> _fallbackGenreAction = {
    'Unidade A': 45,
    'Unidade B': 55,
  };
  static const Map<String, double> _fallbackGenreComedy = {
    'Unidade A': 70,
    'Unidade B': 30,
  };

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    try {
      final unitsData = await _service.getUnitsForCurrentManager();

      final options = unitsData
          .map(
            (unit) => _UnitOption(
              id: unit['id'] as String? ?? '',
              name: (unit['name'] as String? ?? '').trim(),
              capacity: _parseCapacity(unit['capacity']),
            ),
          )
          .where((option) => option.name.isNotEmpty)
          .toList();

      final seenNames = <String>{};
      final filtered = <_UnitOption>[];
      for (final option in options) {
        if (option.id.isNotEmpty && seenNames.add(option.name)) {
          filtered.add(option);
        }
      }

      if (!mounted) return;

      if (filtered.isEmpty) {
        setState(() {
          _unitOptions.clear();
          _unitNames = ['Unidade A', 'Unidade B'];
          _selectedUnit1 = 'Unidade A';
          _selectedUnit2 = 'Unidade B';
          _isLoading = false;
        });
        return;
      }

      _unitOptions
        ..clear()
        ..addAll(filtered);

      final names = filtered.map((option) => option.name).toList();

      setState(() {
        _unitNames = names;
        _selectedUnit1 = names.first;
        _selectedUnit2 = names.length > 1 ? names[1] : names.first;
        _isLoading = false;
      });

      await _preloadMetricsForSelection();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _unitOptions.clear();
        _unitNames = ['Unidade A', 'Unidade B'];
        _selectedUnit1 = 'Unidade A';
        _selectedUnit2 = 'Unidade B';
        _isLoading = false;
      });
    }
  }

  Future<void> _preloadMetricsForSelection() async {
    final ids = <String>{};
    final id1 = _getUnitId(_selectedUnit1);
    if (id1 != null) ids.add(id1);
    final id2 = _getUnitId(_selectedUnit2);
    if (id2 != null) ids.add(id2);

    if (ids.isEmpty) return;

    setState(() => _isLoadingMetrics = true);
    try {
      await Future.wait(ids.map(_ensureMetrics));
    } finally {
      if (mounted) {
        setState(() => _isLoadingMetrics = false);
      }
    }
  }

  Future<void> _ensureMetrics(String unitId) async {
    if (_metricsCache.containsKey(unitId)) return;

    try {
      final audiences = await _service.getAudienceByUnit(unitId);
      final metrics = _AudienceMetrics.fromEntries(audiences);
      if (!mounted) return;
      setState(() {
        _metricsCache[unitId] = metrics;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _metricsCache[unitId] = _AudienceMetrics.empty();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF9B0000)),
        ),
      );
    }

    final hasTwoUnits =
        _unitNames.length >= 2 && _selectedUnit1 != null && _selectedUnit2 != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comparar Unidades',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_unitNames.length >= 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUnitDropdown(
                    'Unidade 1',
                    _selectedUnit1!,
                    (value) => _onUnitChanged(value, isFirst: true),
                  ),
                  _buildUnitDropdown(
                    'Unidade 2',
                    _selectedUnit2!,
                    (value) => _onUnitChanged(value, isFirst: false),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Text(
                  'Cadastre pelo menos duas unidades para comparar.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: !hasTwoUnits
                  ? const Center(
                      child: Text(
                        'Selecione duas unidades para comparar.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : (_isLoadingMetrics
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF9B0000),
                          ),
                        )
                      : ListView(
                          children: [
                            _buildComparisonCard(
                              title: 'Renda de Tickets (%)',
                              color1: Colors.red,
                              color2: Colors.white,
                              value1: _ticketRevenuePercent(
                                _selectedUnit1,
                                versus: _selectedUnit2,
                              ),
                              value2: _ticketRevenuePercent(
                                _selectedUnit2,
                                versus: _selectedUnit1,
                              ),
                            ),
                            _buildComparisonCard(
                              title: 'Renda em Pipoca (%)',
                              color1: Colors.red,
                              color2: Colors.white,
                              value1: _popcornRevenuePercent(_selectedUnit1),
                              value2: _popcornRevenuePercent(_selectedUnit2),
                            ),
                            _buildComparisonCard(
                              title: 'Idade média (anos)',
                              color1: Colors.red,
                              color2: Colors.white,
                              value1: _averageAge(_selectedUnit1),
                              value2: _averageAge(_selectedUnit2),
                              isPercentage: false,
                              customLabel1:
                                  '${_averageAge(_selectedUnit1).toStringAsFixed(1)} anos',
                              customLabel2:
                                  '${_averageAge(_selectedUnit2).toStringAsFixed(1)} anos',
                            ),
                            _buildComparisonCard(
                              title: 'Ocupação Média (%)',
                              color1: Colors.red,
                              color2: Colors.white,
                              value1: _occupancyPercent(_selectedUnit1),
                              value2: _occupancyPercent(_selectedUnit2),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Gênero Preferido (em % de público)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildGenreChart(),
                            for (final genre in _allGenreKeys()) ...[
                              const SizedBox(height: 8),
                              _buildComparisonCard(
                                title: '$genre (%)',
                                color1: Colors.red,
                                color2: Colors.white,
                                value1: _genrePercent(_selectedUnit1, genre),
                                value2: _genrePercent(_selectedUnit2, genre),
                              ),
                            ],
                          ],
                        )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitDropdown(
    String label,
    String selected,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        DropdownButton<String>(
          value: selected,
          items: _unitNames
              .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildComparisonCard({
    required String title,
    required Color color1,
    required Color color2,
    required double value1,
    required double value2,
    bool isPercentage = true,
    String? customLabel1,
    String? customLabel2,
  }) {
    double sanitize(double value) {
      if (value.isNaN) return 0.0;
      return isPercentage ? value.clamp(0, 100).toDouble() : value;
    }

    final safeValue1 = sanitize(value1);
    final safeValue2 = sanitize(value2);
    final labelValue1 = customLabel1 ??
        (isPercentage
            ? '${safeValue1.toStringAsFixed(1)}%'
            : safeValue1.toStringAsFixed(1));
    final labelValue2 = customLabel2 ??
        (isPercentage
            ? '${safeValue2.toStringAsFixed(1)}%'
            : safeValue2.toStringAsFixed(1));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 60,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: safeValue1,
                          color: color1,
                          width: 14,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: safeValue2,
                          color: color2,
                          width: 14,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _legend(color1, _selectedUnit1 ?? '', labelValue1),
                _legend(color2, _selectedUnit2 ?? '', labelValue2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreChart() {
    final data = _genreChartData();
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: entries.map((entry) {
        final width = entry.value.clamp(0, 100).toDouble();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: width,
                height: 14,
                child: Container(color: Colors.red),
              ),
              const SizedBox(width: 8),
              Text('${entry.key} (${entry.value.toStringAsFixed(0)}%)'),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _legend(Color color, String label, String valueLabel) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text(
              valueLabel,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onUnitChanged(String? value, {required bool isFirst}) async {
    if (value == null) return;
    setState(() {
      if (isFirst) {
        _selectedUnit1 = value;
      } else {
        _selectedUnit2 = value;
      }
    });
    await _preloadMetricsForSelection();
  }

  double _ticketRevenuePercent(String? unitName, {String? versus}) {
    final metrics = _metricsFor(unitName);
    if (metrics == null || metrics.total == 0) {
      return _fallbackValue(_fallbackTicketRevenue, unitName);
    }

    final otherMetrics = _metricsFor(versus);
    final self = metrics.total.toDouble();
    final other = otherMetrics?.total.toDouble() ?? 0;
    final denominator = self + other;
    if (denominator == 0) {
      return _fallbackValue(_fallbackTicketRevenue, unitName);
    }
    return (self / denominator * 100).clamp(0, 100);
  }

  double _popcornRevenuePercent(String? unitName) {
    final metrics = _metricsFor(unitName);
    if (metrics == null || metrics.total == 0) {
      return _fallbackValue(_fallbackPopcornRevenue, unitName);
    }
    final value = metrics.formatPercentages['3D'] ?? 0;
    return value.clamp(0, 100);
  }

  double _occupancyPercent(String? unitName) {
    final metrics = _metricsFor(unitName);
    final capacity = _getUnitCapacity(unitName);
    if (metrics == null || metrics.total == 0 || capacity <= 0) {
      return _fallbackValue(_fallbackOccupancy, unitName);
    }
    final percent = (metrics.total / capacity) * 100;
    return percent.clamp(0, 100);
  }

  double _averageAge(String? unitName) {
    final metrics = _metricsFor(unitName);
    if (metrics == null || metrics.total == 0) {
      return 0;
    }
    return metrics.averageAge.clamp(0, 120);
  }

  double _genrePercent(String? unitName, String genre) {
    final metrics = _metricsFor(unitName);
    if (metrics != null && metrics.total > 0) {
      return (metrics.genrePercentages[genre] ?? 0).clamp(0, 100);
    }

    if (_usingFallbackUnits()) {
      if (genre == 'Ação') {
        return _fallbackGenreAction[unitName ?? ''] ??
            (_fallbackGenreChart[genre] ?? 0);
      }
      if (genre == 'Comédia') {
        return _fallbackGenreComedy[unitName ?? ''] ??
            (_fallbackGenreChart[genre] ?? 0);
      }
      return _fallbackGenreChart[genre] ?? 0;
    }

    return 0;
  }

  Map<String, double> _genreChartData() {
    final keys = _allGenreKeys();
    if (keys.isEmpty) {
      return _fallbackGenreChart;
    }

    final values = <String, double>{};
    for (final key in keys) {
      final value1 = _genrePercent(_selectedUnit1, key);
      final value2 = _genrePercent(_selectedUnit2, key);
      final divisor = (_selectedUnit1 != null ? 1 : 0) +
          (_selectedUnit2 != null ? 1 : 0);
      final average = divisor == 0
          ? 0.0
          : (value1 + value2) / divisor;
      values[key] = average.clamp(0, 100);
    }
    return values;
  }

  List<String> _allGenreKeys() {
    final keys = <String>{};
    keys.addAll(_metricsFor(_selectedUnit1)?.genrePercentages.keys ?? {});
    keys.addAll(_metricsFor(_selectedUnit2)?.genrePercentages.keys ?? {});
    if (keys.isEmpty) {
      keys.addAll(_fallbackGenreChart.keys);
    }
    final list = keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  bool _usingFallbackUnits() {
    return _unitOptions.isEmpty &&
        _unitNames.every((name) => name.startsWith('Unidade '));
  }

  _AudienceMetrics? _metricsFor(String? unitName) {
    final id = _getUnitId(unitName);
    if (id == null) return null;
    return _metricsCache[id];
  }

  String? _getUnitId(String? unitName) {
    final option = _optionForName(unitName);
    if (option == null || option.id.isEmpty) return null;
    return option.id;
  }

  int _getUnitCapacity(String? unitName) {
    final option = _optionForName(unitName);
    return option?.capacity ?? 0;
  }

  _UnitOption? _optionForName(String? unitName) {
    if (unitName == null) return null;
    for (final option in _unitOptions) {
      if (option.name == unitName) return option;
    }
    return null;
  }

  double _fallbackValue(Map<String, double> fallback, String? unitName) {
    if (unitName == null) {
      return fallback.values.isNotEmpty ? fallback.values.first : 0;
    }
    return fallback[unitName] ?? 0;
  }

  int _parseCapacity(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
