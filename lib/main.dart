import 'package:flutter/material.dart';

void main() {
  runApp(const FuelCalculatorApp());
}

class FuelCalculatorApp extends StatelessWidget {
  const FuelCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Combustible',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B365D)),
        useMaterial3: true,
      ),
      home: const FuelCalculatorScreen(),
    );
  }
}

class FuelCalculatorScreen extends StatefulWidget {
  const FuelCalculatorScreen({super.key});

  @override
  State<FuelCalculatorScreen> createState() => _FuelCalculatorScreenState();
}

class _FuelCalculatorScreenState extends State<FuelCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _distanceController = TextEditingController();
  final _efficiencyController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isRoundTrip = false; // Sencillo o Redondo

  // Resultados
  double? _totalGallons;
  double? _totalLiters;
  double? _totalCost;

  void _calculateFuel() {
    if (_formKey.currentState!.validate()) {
      double distance = double.parse(_distanceController.text);
      double efficiency = double.parse(_efficiencyController.text);
      double pricePerGallon = double.parse(_priceController.text);

      // Si es viaje redondo (ida y vuelta), multiplicamos la distancia por 2
      if (_isRoundTrip) {
        distance *= 2;
      }

      // Cálculo de galones consumidos: Distancia / Rendimiento (km/galón)
      double gallons = distance / efficiency;

      // Conversión a litros (1 galón americano ≈ 3.78541 litros)
      double liters = gallons * 3.78541;

      // Costo total en Quetzales: Galones * Precio por galón
      double cost = gallons * pricePerGallon;

      setState(() {
        _totalGallons = gallons;
        _totalLiters = liters;
        _totalCost = cost;
      });
    }
  }

  void _reset() {
    _distanceController.clear();
    _efficiencyController.clear();
    _priceController.clear();
    setState(() {
      _isRoundTrip = false;
      _totalGallons = null;
      _totalLiters = null;
      _totalCost = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora de Combustible',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B365D),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Distancia
                      TextFormField(
                        controller: _distanceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Distancia de viaje (km)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.map),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese la distancia';
                          if (double.tryParse(value) == null || double.parse(value) <= 0) {
                            return 'Ingrese un valor válido mayor a 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Tipo de viaje (Switch / Interruptor)
                      SwitchListTile(
                        title: const Text('¿Viaje Redondo (Ida y vuelta)?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        subtitle: Text(_isRoundTrip ? 'Se duplicará la distancia' : 'Solo viaje de ida', style: const TextStyle(fontSize: 12)),
                        value: _isRoundTrip,
                        activeColor: const Color(0xFF1B365D),
                        onChanged: (bool value) {
                          setState(() {
                            _isRoundTrip = value;
                          });
                        },
                      ),
                      const Divider(height: 24),

                      // Rendimiento
                      TextFormField(
                        controller: _efficiencyController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Rendimiento del vehículo (km/galón)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.speed),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese el rendimiento';
                          if (double.tryParse(value) == null || double.parse(value) <= 0) {
                            return 'Ingrese un valor válido mayor a 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Precio del combustible
                      TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Precio por galón (Q)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese el precio';
                          if (double.tryParse(value) == null || double.parse(value) <= 0) {
                            return 'Ingrese un valor válido mayor a 0';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _calculateFuel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B365D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('CALCULAR COSTO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Limpiar',
                  ),
                ],
              ),

              // Resultados
              if (_totalCost != null) ...[
                const SizedBox(height: 25),
                Card(
                  color: const Color(0xFFE8EEF5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'COSTO TOTAL ESTIMADO',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B365D)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Q ${_totalCost!.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1B365D)),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Consumo en Galones:'),
                            Text('${_totalGallons!.toStringAsFixed(2)} gal', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Consumo en Litros:'),
                            Text('${_totalLiters!.toStringAsFixed(2)} L', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
